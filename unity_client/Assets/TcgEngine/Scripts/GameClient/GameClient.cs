﻿using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using Unity.Netcode;
using System.Threading.Tasks;

namespace TcgEngine.Client
{
    /// <summary>
    /// Main script for the client-side of the game, should be in game scene only
    /// Will connect to server, then connect to the game on that server (with uid) and then will send game settings
    /// During the game, will send all actions performed by the player and receive game refreshes
    /// </summary>
    public class GameClient : MonoBehaviour
    {
        //--- These settings are set in the menu scene and when the game start will be sent to server

        public static GameSettings game_settings = GameSettings.Default;
        public static PlayerSettings player_settings = PlayerSettings.Default;
        public static PlayerSettings ai_settings = PlayerSettings.DefaultAI;
        public static string observe_user = null; //Which user should it observe, null if not an obs

        //-----

        public UnityAction onConnectServer;
        public UnityAction onConnectGame;
        public UnityAction<int> onPlayerReady;

        public UnityAction onGameStart;
        public UnityAction<int> onGameEnd; //winner player_id
        public UnityAction<int> onNewTurn; //current player_id

        public UnityAction<Card, Slot> onCardPlayed;
        public UnityAction<Card, Slot> onCardMoved;
        public UnityAction<Slot> onCardSummoned;
        public UnityAction<Card> onCardTransformed;
        public UnityAction<Card> onCardDiscarded;
        public UnityAction<int> onCardDraw;
        public UnityAction<int> onValueRolled;

        public UnityAction<AbilityData, Card> onAbilityStart;
        public UnityAction<AbilityData, Card, Card> onAbilityTargetCard; //Ability, Caster, Target
        public UnityAction<AbilityData, Card, Player> onAbilityTargetPlayer;
        public UnityAction<AbilityData, Card, Slot> onAbilityTargetSlot;
        public UnityAction<AbilityData, Card> onAbilityEnd;
        public UnityAction<Card, Card> onSecretTrigger; //Secret, Triggerer
        public UnityAction<Card, Card> onSecretResolve; //Secret, Triggerer

        public UnityAction<Card, Card> onAttackStart; //Attacker, Defender
        public UnityAction<Card, Card> onAttackEnd; //Attacker, Defender
        public UnityAction<Card, Player> onAttackPlayerStart;
        public UnityAction<Card, Player> onAttackPlayerEnd;

        public UnityAction<int, string> onChatMsg; //player_id, msg
        public UnityAction<string> onServerMsg; //msg
        public UnityAction onRefreshAll;

        private int player_id = 0; //Player playing on this device;
        private Game game_data;

        private bool observe_mode = false;
        private int observe_player_id = 0;
        private float timer = 0f;


        private Dictionary<ushort, RefreshEvent> registered_commands = new Dictionary<ushort, RefreshEvent>();

        private static GameClient _instance;

        protected virtual void Awake()
        {
            _instance = this;
            Application.targetFrameRate = 120;
        }

        protected virtual void Start()
        {
            Debug.Log("GameClient Start");
            RegisterRefresh(GameAction.Connected, OnConnectedToGame);
            RegisterRefresh(GameAction.PlayerReady, OnPlayerReady);
            RegisterRefresh(GameAction.GameStart, OnGameStart);
            RegisterRefresh(GameAction.GameEnd, OnGameEnd);
            RegisterRefresh(GameAction.NewTurn, OnNewTurn);
            RegisterRefresh(GameAction.CardPlayed, OnCardPlayed);
            RegisterRefresh(GameAction.CardMoved, OnCardMoved);
            RegisterRefresh(GameAction.CardSummoned, OnCardSummoned);
            RegisterRefresh(GameAction.CardTransformed, OnCardTransformed);
            RegisterRefresh(GameAction.CardDiscarded, OnCardDiscarded);
            RegisterRefresh(GameAction.CardDrawn, OnCardDraw);
            RegisterRefresh(GameAction.ValueRolled, OnValueRolled);

            RegisterRefresh(GameAction.AttackStart, OnAttackStart);
            RegisterRefresh(GameAction.AttackEnd, OnAttackEnd);
            RegisterRefresh(GameAction.AttackPlayerStart, OnAttackPlayerStart);
            RegisterRefresh(GameAction.AttackPlayerEnd, OnAttackPlayerEnd);

            RegisterRefresh(GameAction.AbilityTrigger, OnAbilityTrigger);
            RegisterRefresh(GameAction.AbilityTargetCard, OnAbilityTargetCard);
            RegisterRefresh(GameAction.AbilityTargetPlayer, OnAbilityTargetPlayer);
            RegisterRefresh(GameAction.AbilityTargetSlot, OnAbilityTargetSlot);
            RegisterRefresh(GameAction.AbilityEnd, OnAbilityAfter);

            RegisterRefresh(GameAction.SecretTriggered, OnSecretTrigger);
            RegisterRefresh(GameAction.SecretResolved, OnSecretResolve);

            RegisterRefresh(GameAction.ChatMessage, OnChat);
            RegisterRefresh(GameAction.ServerMessage, OnServerMsg);
            RegisterRefresh(GameAction.RefreshAll, OnRefreshAll);

            TcgNetwork.Get().onConnect += OnConnectedServer;
            TcgNetwork.Get().Messaging.ListenMsg("refresh", OnReceiveRefresh);

            ConnectToAPI();
            ConnectToServer();
        }

        protected virtual void OnDestroy()
        {
            TcgNetwork.Get().onConnect -= OnConnectedServer;
            TcgNetwork.Get().Messaging.UnListenMsg("refresh");
        }

        protected virtual void Update()
        {
            bool is_starting = game_data == null || game_data.state == GameState.Connecting;
            bool is_client = !game_settings.IsHost();
            bool is_connecting = TcgNetwork.Get().IsConnecting();
            bool is_connected = TcgNetwork.Get().IsConnected();

            //Exit game scene if cannot connect after a while
            if (is_starting && is_client)
            {
                timer += Time.deltaTime;
                if (timer > 10f)
                {
                    SceneNav.GoTo("Menu");
                }
            }

            //Reconnect to server
            if (!is_starting && !is_connecting && is_client && !is_connected)
            {
                timer += Time.deltaTime;
                if (timer > 5f)
                {
                    timer = 0f;
                    ConnectToServer();
                }
            }
        }

        //--------------------

        public virtual void ConnectToAPI()
        {
            //Should already be logged in from the menu
            //If not connected, start in test mode (this means game scene was launched directly from Unity)
            if (!Authenticator.Get().IsSignedIn())
            {
                Authenticator.Get().LoginTest("Player");

                if (!player_settings.HasDeck())
                {
                    player_settings.deck = new UserDeckData(GameplayData.Get().test_deck);
                }

                if (!ai_settings.HasDeck())
                {
                    ai_settings.deck = new UserDeckData(GameplayData.Get().test_deck_ai);
                    ai_settings.ai_level = GameplayData.Get().ai_level;
                }
            }

            //Set adventure decks
            LevelData level = game_settings.GetLevel();
            if (level != null)
            {
                player_settings.deck = new UserDeckData(level.player_deck);
                ai_settings.deck = new UserDeckData(level.ai_deck);
            }

            //Set avatar, cardback based on your api data
            UserData udata = Authenticator.Get().UserData;
            if (udata != null)
            {
                player_settings.avatar = udata.GetAvatar();
                player_settings.cardback = udata.GetCardback();
            }
        }

        public virtual async void ConnectToServer()
        {
            Debug.Log("GameClient ConnectToServer....");
            await Task.Yield(); //Wait for initialization to finish

            if (TcgNetwork.Get().IsActive())
                return; // Already connected

            if (game_settings.IsHost() && NetworkData.Get().solo_type == SoloType.Offline)
            {
                TcgNetwork.Get()
                    .StartHostOffline(); //WebGL dont support hosting a game, must join a dedicated server, in solo it starts a offline mode that doesn't use netcode at all
            }
            else if (game_settings.IsHost())
            {
                TcgNetwork.Get()
                    .StartHost(NetworkData.Get()
                        .port); //Host a game, either solo or for P2P, still using netcode in solo to have consistant behavior when testing solo vs multi
            }
            else
            {
                TcgNetwork.Get().StartClient(game_settings.GetUrl(), NetworkData.Get().port); //Join server
            }
        }

        public virtual async void ConnectToGame(string uid)
        {
            await Task.Yield(); //Wait for initialization to finish

            if (!TcgNetwork.Get().IsActive())
                return; //Not connected to server

            Debug.Log("Connect to Game: " + uid);

            MsgPlayerConnect nplayer = new MsgPlayerConnect();
            nplayer.user_id = Authenticator.Get().UserID;
            nplayer.username = Authenticator.Get().Username;
            nplayer.game_uid = uid;
            nplayer.nb_players = game_settings.nb_players;
            nplayer.observer = game_settings.game_type == GameType.Observer;

            Messaging.SendObject("connect", ServerID, nplayer, NetworkDelivery.Reliable);
        }

        public virtual void SendGameSettings()
        {
            if (game_settings.IsOffline())
            {
                //Solo mode, send both your settings and AI settings
                SendGameplaySettings(game_settings);
                SendPlayerSettingsAI(ai_settings);
                SendPlayerSettings(player_settings);
            }
            else
            {
                //Online mode, only send your own settings
                SendGameplaySettings(game_settings);
                SendPlayerSettings(player_settings);
            }
        }

        public virtual void Disconnect()
        {
            TcgNetwork.Get().Disconnect();
        }

        private void RegisterRefresh(ushort tag, UnityAction<SerializedData> callback)
        {
            Debug.Log("RegisterRefresh:" + tag);

            RefreshEvent cmdevt = new RefreshEvent();
            cmdevt.tag = tag;
            cmdevt.callback = callback;
            registered_commands.Add(tag, cmdevt);
        }

        public void OnReceiveRefresh(ulong client_id, FastBufferReader reader)
        {
            reader.ReadValueSafe(out ushort type);
            bool found = registered_commands.TryGetValue(type, out RefreshEvent command);
            if (found)
            {
                command.callback.Invoke(new SerializedData(reader));
            }
        }

        //--------------------------

        public void SendPlayerSettings(PlayerSettings psettings)
        {
            Debug.Log("GameClient SendPlayerSettings");
            //+
            //    string.Format("{0},{1}", psettings.username, psettings.deck.cards[0]));

            DeckPuzzleData pdeck = DeckPuzzleData.Get(psettings.deck.tid);

            int hp_max = pdeck != null ? pdeck.start_hp : GameplayData.Get().hp_start;
            int mana_max = pdeck != null ? pdeck.start_mana : GameplayData.Get().mana_start;
            //Draw starting cards
            int dcards = pdeck != null ? pdeck.start_cards : GameplayData.Get().cards_start;


            if (MudManager.Get().useMud)
            {
                MudManager.Get().PlayerSetting(psettings.username, game_settings.game_uid, psettings.deck.tid, false,
                    hp_max, mana_max, dcards);
            }
            else
            {
                SendAction(GameAction.PlayerSettings, psettings, NetworkDelivery.ReliableFragmentedSequenced);
            }
        }

        public void OnGameSettingSuccess(string message)
        {
            Debug.Log("OnGameSettingSuccess:" + message);
            // game_data.settings = new GameSettings();
            // game_data.settings.game_uid = "";
            // game_data.

            if (observe_mode)
                SetObserverMode(observe_user);

            onConnectGame.Invoke();


            game_data.settings.game_mode = GameMode.Casual;
            game_data.settings.game_type = GameType.Adventure;
            // game_uid = {string} "VdlXG2Hm26C7"
            game_data.settings.level = "adventure2";
            game_data.settings.nb_players = 2;
            game_data.settings.scene = "Game";
            game_data.settings.server_url = "";
            onRefreshAll?.Invoke();
        }

        public void OnPlayerSettingSuccess(string message)
        {
            Debug.Log("OnPlayerSettingSuccess:" + message);
            MudPlayerSettingResult result = JsonUtility.FromJson<MudPlayerSettingResult>(message);
            foreach (var player in game_data.players)
            {
                Debug.Log("OnPlayerSettingSuccess: player=" + player.username);
                if (player.username == result.player_name)
                {
                    Debug.Log("OnPlayerSettingSuccess find player:" + result.player_name);
                    for (var i = 0; i < result.all.Length; i++)
                    {
                        if (player.IsReady())
                        {
                            Debug.Log(player.username + "IsReady");
                            continue;
                        }

                        var card_key = result.all[i];
                        var card_id_key = result.cards[i];
                        var card_id = MudManager.Get().GetCardIdByHex(card_id_key);

                        Debug.Log("CardId:" + card_id);


                        // foreach (var hand_card in player.cards_hand)
                        // {
                        //     Debug.Log("HandCard:"+hand_card.card_id);
                        //     if (hand_card.card_id == card_id)
                        //     {
                        //         Debug.Log("HandCard Find:"+hand_card.card_id);
                        //         hand_card.uid = card_key;
                        //     }
                        // }

                        CardData card_data = CardData.Get(card_id);
                        Card card = Card.Create(card_data, VariantData.Get("normal"), player, card_key);
                        if (Array.Exists(result.deck, element => element == card_key))
                        {
                            Debug.Log("PlayerDeckAddCard:" + card.card_id + " : " + card.uid);
                            player.cards_deck.Add(card);
                        }

                        if (Array.Exists(result.hand, element => element == card_key))
                        {
                            Debug.Log("PlayerHand AddCard:" + card.card_id + " : " + card.uid);
                            player.cards_hand.Add(card);
                        }

                        if (Array.Exists(result.board, element => element == card_key))
                        {
                            Debug.Log("PlayerBoard AddCard:" + card.card_id + " : " + card.uid);
                            player.cards_board.Add(card);
                        }
                    }

                    player.ready = true;
                    player.mana_max = 5;
                    player.mana = 5;
                    player.hp = 10;
                    player.hp_max = 10;
                    Debug.Log("do onPlayerReady:" + player.player_id);
                    onPlayerReady.Invoke(player.player_id);
                }
            }

            if (game_data.players[0].IsReady() && game_data.players[1].IsReady())
            {
                Debug.Log("GameStarted");
                Debug.Log("Player 0:" + game_data.players[0].player_id + "," + game_data.players[0].username);
                Debug.Log("Player 1:" + game_data.players[1].player_id + "," + game_data.players[1].username);


                game_data.state = GameState.Play;
                game_data.first_player = 0;
                game_data.current_player = game_data.first_player;
                game_data.turn_count = 1;
                game_data.turn_timer = GameplayData.Get().turn_duration;


                onGameStart?.Invoke();

                game_data.phase = GamePhase.StartTurn;

                // player.hp_max = pdeck != null ? pdeck.start_hp : GameplayData.Get().hp_start;
                // player.hp = player.hp_max;
                // player.mana_max = pdeck != null ? pdeck.start_mana : GameplayData.Get().mana_start;
                // player.mana = player.mana_max;

                onNewTurn?.Invoke(game_data.players[0].player_id);
            }
        }

        public void SendPlayerSettingsAI(PlayerSettings psettings)
        {
            DeckPuzzleData pdeck = DeckPuzzleData.Get(psettings.deck.tid);

            int hp_max = pdeck != null ? pdeck.start_hp : GameplayData.Get().hp_start;
            int mana_max = pdeck != null ? pdeck.start_mana : GameplayData.Get().mana_start;
            //Draw starting cards
            int dcards = pdeck != null ? pdeck.start_cards : GameplayData.Get().cards_start;


            MudManager.Get().PlayerSetting(psettings.username, game_settings.game_uid, psettings.deck.tid, true,
                hp_max, mana_max, dcards);

            SendAction(GameAction.PlayerSettingsAI, psettings, NetworkDelivery.ReliableFragmentedSequenced);
        }

        public void SendGameplaySettings(GameSettings settings)
        {
            MudManager.Get().GameSetting(settings.game_uid, settings.nb_players, settings.level);
            SendAction(GameAction.GameSettings, settings, NetworkDelivery.ReliableFragmentedSequenced);
        }

        public void PlayCard(Card card, Slot slot)
        {
            MsgPlayCard mdata = new MsgPlayCard();
            mdata.card_uid = card.uid;
            mdata.slot = slot;

            Debug.Log("GameClient PlayCard:" + card.uid + "," + slot.y + "," + slot.x + "," + slot.p);

            SendAction(GameAction.PlayCard, mdata);

            string player_name = GetPlayer().username;

            MudManager.Get().PlayCard(this.game_data.game_uid, player_name, card.CardData.id, slot.x,
                slot.y,
                slot.p, false, card.uid);
        }

        public void OnPlayCardSuccess(string message)
        {
            Debug.Log("OnPlayCardSuccess" + message);

            MudPlayCard msg = JsonUtility.FromJson<MudPlayCard>(message);

            Slot slot = new Slot(msg.slot_x, msg.slot_y, msg.slot_p);

            Card card = game_data.GetCard(msg.card_uid);
            if (card == null)
            {
                Debug.Log("Card Not Found" + msg.card_uid);
            }

            card.slot = slot;

            var player = game_data.GetPlayer(card.player_id);
            player.RemoveCardFromAllGroups(card);
            player.cards_board.Add(card);

            onCardPlayed?.Invoke(card, slot);
            onRefreshAll?.Invoke();
        }

        public void AttackTarget(Card card, Card target)
        {
            MsgAttack mdata = new MsgAttack();
            mdata.attacker_uid = card.uid;
            mdata.target_uid = target.uid;

            MudManager.Get().AttackCard(game_data.game_uid, GetPlayer().username, card.uid, target.uid);

            SendAction(GameAction.Attack, mdata);
        }

        public void AttackPlayer(Card card, Player target)
        {
            MsgAttackPlayer mdata = new MsgAttackPlayer();
            mdata.attacker_uid = card.uid;
            mdata.target_id = target.player_id;


            SendAction(GameAction.AttackPlayer, mdata);

            MudManager.Get().AttackPlayer(game_data.game_uid, card.uid, target.player_id);
        }

        public void Move(Card card, Slot slot)
        {
            MsgPlayCard mdata = new MsgPlayCard();
            mdata.card_uid = card.uid;
            mdata.slot = slot;
            SendAction(GameAction.Move, mdata);

            string player_name = GetPlayer().username;


            MudManager.Get().MoveCard(this.game_data.game_uid, player_name, card.CardData.id, slot.x,
                slot.y,
                slot.p, false, card.uid);
        }

        public void OnMoveCardSuccess(string message)
        {
            Debug.Log("OnMoveCardSuccess:" + message);


            MudPlayCard msg = JsonUtility.FromJson<MudPlayCard>(message);

            Slot slot = new Slot(msg.slot_x, msg.slot_y, msg.slot_p);

            Card card = game_data.GetCard(msg.card_uid);

            if (card == null)
            {
                Debug.Log("Card Not Found" + msg.card_uid);
            }

            card.slot = slot;

            var player = game_data.GetPlayer(card.player_id);
            player.RemoveCardFromAllGroups(card);
            player.cards_board.Add(card);

            onCardMoved?.Invoke(card, slot);
            onRefreshAll?.Invoke();
        }

        public void CastAbility(Card card, AbilityData ability)
        {
            MsgCastAbility mdata = new MsgCastAbility();
            mdata.caster_uid = card.uid;
            mdata.ability_id = ability.id;
            mdata.target_uid = "";
            SendAction(GameAction.CastAbility, mdata);
        }

        public void SelectCard(Card card)
        {
            MsgCard mdata = new MsgCard();
            mdata.card_uid = card.uid;
            SendAction(GameAction.SelectCard, mdata);
        }

        public void SelectPlayer(Player player)
        {
            MsgPlayer mdata = new MsgPlayer();
            mdata.player_id = player.player_id;
            SendAction(GameAction.SelectPlayer, mdata);
        }

        public void SelectSlot(Slot slot)
        {
            SendAction(GameAction.SelectSlot, slot);
        }

        public void SelectChoice(int c)
        {
            MsgInt choice = new MsgInt();
            choice.value = c;
            SendAction(GameAction.SelectChoice, choice);
        }

        public void CancelSelection()
        {
            SendAction(GameAction.CancelSelect);
        }

        public void SendChatMsg(string msg)
        {
            MsgChat chat = new MsgChat();
            chat.msg = msg;
            chat.player_id = player_id;
            SendAction(GameAction.ChatMessage, chat);
        }

        public void EndTurn()
        {
            SendAction(GameAction.EndTurn);

            MudManager.Get().EndTurn(game_data.game_uid, GetPlayer().username, GetPlayerID());
        }

        public void Resign()
        {
            SendAction(GameAction.Resign);
        }

        public void SetObserverMode(int player_id)
        {
            observe_mode = true;
            observe_player_id = player_id;
        }

        public void SetObserverMode(string username)
        {
            observe_player_id = 0; //Default value of observe_user not found

            Game data = GetGameData();
            foreach (Player player in data.players)
            {
                if (player.username == username)
                {
                    observe_player_id = player.player_id;
                }
            }
        }

        public void SendAction<T>(ushort type, T data, NetworkDelivery delivery = NetworkDelivery.Reliable)
            where T : INetworkSerializable
        {
            Debug.Log("SendAction 1:" + MudManager.GetCommandString(type));
            MudManager.SendTask(type);
            FastBufferWriter writer =
                new FastBufferWriter(128, Unity.Collections.Allocator.Temp, TcgNetwork.MsgSizeMax);
            writer.WriteValueSafe(type);
            writer.WriteNetworkSerializable(data);
            Messaging.Send("action", ServerID, writer, delivery);
            writer.Dispose();
        }

        public void SendAction(ushort type, int data)
        {
            Debug.Log("SendAction 2:" + MudManager.GetCommandString(type));
            MudManager.SendTask(type);

            FastBufferWriter writer =
                new FastBufferWriter(128, Unity.Collections.Allocator.Temp, TcgNetwork.MsgSizeMax);
            writer.WriteValueSafe(type);
            writer.WriteValueSafe(data);
            Messaging.Send("action", ServerID, writer, NetworkDelivery.Reliable);
            writer.Dispose();
        }

        public void SendAction(ushort type)
        {
            Debug.Log("SendAction 3:" + MudManager.GetCommandString(type));
            MudManager.SendTask(type);

            FastBufferWriter writer =
                new FastBufferWriter(128, Unity.Collections.Allocator.Temp, TcgNetwork.MsgSizeMax);
            writer.WriteValueSafe(type);
            Messaging.Send("action", ServerID, writer, NetworkDelivery.Reliable);
            writer.Dispose();
        }

        //--- Receive Refresh ----------------------

        protected virtual void OnConnectedServer()
        {
            Debug.Log("GameClient OnConnectedServer");
            ConnectToGame(game_settings.game_uid);
            onConnectServer?.Invoke();
        }

        protected virtual void OnConnectedToGame(SerializedData sdata)
        {
            MsgAfterConnected msg = sdata.Get<MsgAfterConnected>();
            player_id = msg.player_id;
            game_data = msg.game_data;
            observe_mode = player_id < 0; //Will usually return -1 if its an observer

            if (observe_mode)
                SetObserverMode(observe_user);

            if (onConnectGame != null)
                onConnectGame.Invoke();

            SendGameSettings();
        }

        protected virtual void OnPlayerReady(SerializedData sdata)
        {
            MsgInt msg = sdata.Get<MsgInt>();
            int pid = msg.value;

            if (onPlayerReady != null)
                onPlayerReady.Invoke(pid);
        }

        private void OnGameStart(SerializedData sdata)
        {
            onGameStart?.Invoke();
        }

        private void OnGameEnd(SerializedData sdata)
        {
            MsgPlayer msg = sdata.Get<MsgPlayer>();
            onGameEnd?.Invoke(msg.player_id);
        }

        private void OnNewTurn(SerializedData sdata)
        {
            MsgPlayer msg = sdata.Get<MsgPlayer>();
            onNewTurn?.Invoke(msg.player_id);
        }

        public void OnEndTurnSuccess(string message)
        {
            Debug.Log("OnEndTurnSuccess:" + message);
            MudEndTurnResult result = JsonUtility.FromJson<MudEndTurnResult>(message);
            onNewTurn?.Invoke(result.player_id);
        }

        private void OnCardPlayed(SerializedData sdata)
        {
            MsgPlayCard msg = sdata.Get<MsgPlayCard>();
            Card card = game_data.GetCard(msg.card_uid);
            onCardPlayed?.Invoke(card, msg.slot);
        }

        private void OnCardSummoned(SerializedData sdata)
        {
            MsgPlayCard msg = sdata.Get<MsgPlayCard>();
            onCardSummoned?.Invoke(msg.slot);
        }

        private void OnCardMoved(SerializedData sdata)
        {
            MsgPlayCard msg = sdata.Get<MsgPlayCard>();
            Card card = game_data.GetCard(msg.card_uid);
            onCardMoved?.Invoke(card, msg.slot);
        }

        private void OnCardTransformed(SerializedData sdata)
        {
            MsgCard msg = sdata.Get<MsgCard>();
            Card card = game_data.GetCard(msg.card_uid);
            onCardTransformed?.Invoke(card);
        }

        private void OnCardDiscarded(SerializedData sdata)
        {
            MsgCard msg = sdata.Get<MsgCard>();
            Card card = game_data.GetCard(msg.card_uid);
            onCardDiscarded?.Invoke(card);
        }

        private void OnCardDraw(SerializedData sdata)
        {
            MsgInt msg = sdata.Get<MsgInt>();
            onCardDraw?.Invoke(msg.value);
        }

        private void OnValueRolled(SerializedData sdata)
        {
            MsgInt msg = sdata.Get<MsgInt>();
            onValueRolled?.Invoke(msg.value);
        }

        private void OnAttackStart(SerializedData sdata)
        {
            MsgAttack msg = sdata.Get<MsgAttack>();
            Card attacker = game_data.GetCard(msg.attacker_uid);
            Card target = game_data.GetCard(msg.target_uid);
            onAttackStart?.Invoke(attacker, target);
        }

        private void OnAttackEnd(SerializedData sdata)
        {
            MsgAttack msg = sdata.Get<MsgAttack>();
            Card attacker = game_data.GetCard(msg.attacker_uid);
            Card target = game_data.GetCard(msg.target_uid);
            onAttackEnd?.Invoke(attacker, target);
        }

        private void OnAttackPlayerStart(SerializedData sdata)
        {
            MsgAttackPlayer msg = sdata.Get<MsgAttackPlayer>();
            Card attacker = game_data.GetCard(msg.attacker_uid);
            Player target = game_data.GetPlayer(msg.target_id);
            onAttackPlayerStart?.Invoke(attacker, target);
        }

        private void OnAttackPlayerEnd(SerializedData sdata)
        {
            MsgAttackPlayer msg = sdata.Get<MsgAttackPlayer>();
            Card attacker = game_data.GetCard(msg.attacker_uid);
            Player target = game_data.GetPlayer(msg.target_id);
            onAttackPlayerEnd?.Invoke(attacker, target);
        }

        private void OnAbilityTrigger(SerializedData sdata)
        {
            MsgCastAbility msg = sdata.Get<MsgCastAbility>();
            AbilityData ability = AbilityData.Get(msg.ability_id);
            Card caster = game_data.GetCard(msg.caster_uid);
            onAbilityStart?.Invoke(ability, caster);
        }

        private void OnAbilityTargetCard(SerializedData sdata)
        {
            MsgCastAbility msg = sdata.Get<MsgCastAbility>();
            AbilityData ability = AbilityData.Get(msg.ability_id);
            Card caster = game_data.GetCard(msg.caster_uid);
            Card target = game_data.GetCard(msg.target_uid);
            onAbilityTargetCard?.Invoke(ability, caster, target);
        }

        private void OnAbilityTargetPlayer(SerializedData sdata)
        {
            MsgCastAbilityPlayer msg = sdata.Get<MsgCastAbilityPlayer>();
            AbilityData ability = AbilityData.Get(msg.ability_id);
            Card caster = game_data.GetCard(msg.caster_uid);
            Player target = game_data.GetPlayer(msg.target_id);
            onAbilityTargetPlayer?.Invoke(ability, caster, target);
        }

        private void OnAbilityTargetSlot(SerializedData sdata)
        {
            MsgCastAbilitySlot msg = sdata.Get<MsgCastAbilitySlot>();
            AbilityData ability = AbilityData.Get(msg.ability_id);
            Card caster = game_data.GetCard(msg.caster_uid);
            onAbilityTargetSlot?.Invoke(ability, caster, msg.slot);
        }

        private void OnAbilityAfter(SerializedData sdata)
        {
            MsgCastAbility msg = sdata.Get<MsgCastAbility>();
            AbilityData ability = AbilityData.Get(msg.ability_id);
            Card caster = game_data.GetCard(msg.caster_uid);
            onAbilityEnd?.Invoke(ability, caster);
        }

        private void OnSecretTrigger(SerializedData sdata)
        {
            MsgSecret msg = sdata.Get<MsgSecret>();
            Card secret = game_data.GetCard(msg.secret_uid);
            Card triggerer = game_data.GetCard(msg.triggerer_uid);
            onSecretTrigger?.Invoke(secret, triggerer);
        }

        private void OnSecretResolve(SerializedData sdata)
        {
            MsgSecret msg = sdata.Get<MsgSecret>();
            Card secret = game_data.GetCard(msg.secret_uid);
            Card triggerer = game_data.GetCard(msg.triggerer_uid);
            onSecretResolve?.Invoke(secret, triggerer);
        }

        private void OnChat(SerializedData sdata)
        {
            MsgChat msg = sdata.Get<MsgChat>();
            onChatMsg?.Invoke(msg.player_id, msg.msg);
        }

        private void OnServerMsg(SerializedData sdata)
        {
            string msg = sdata.GetString();
            onServerMsg?.Invoke(msg);
        }

        private void OnRefreshAll(SerializedData sdata)
        {
            MsgRefreshAll msg = sdata.Get<MsgRefreshAll>();
            game_data = msg.game_data;
            onRefreshAll?.Invoke();
        }

        //--------------------------

        public virtual bool IsReady()
        {
            return game_data != null && TcgNetwork.Get().IsConnected();
        }

        public Player GetPlayer()
        {
            Game gdata = GetGameData();
            return gdata.GetPlayer(GetPlayerID());
        }

        public Player GetOpponentPlayer()
        {
            Game gdata = GetGameData();
            return gdata.GetPlayer(GetOpponentPlayerID());
        }

        public int GetPlayerID()
        {
            if (observe_mode)
                return observe_player_id;
            return player_id;
        }

        public int GetOpponentPlayerID()
        {
            return GetPlayerID() == 0 ? 1 : 0;
        }

        public virtual bool IsYourTurn()
        {
            Game game_data = GetGameData();
            Player player = GetPlayer();
            return IsReady() && game_data.IsPlayerTurn(player);
        }

        public bool IsObserveMode()
        {
            return observe_mode;
        }

        public Game GetGameData()
        {
            return game_data;
        }

        public bool HasEnded()
        {
            return game_data.HasEnded();
        }

        private void OnApplicationQuit()
        {
            Resign(); //Auto Resign before closing the app. NOTE: doesn't seem to work since the msg dont have time to be sent before it closes
        }

        public bool IsHost
        {
            get { return TcgNetwork.Get().IsHost; }
        }

        public ulong ServerID
        {
            get { return TcgNetwork.Get().ServerID; }
        }

        public NetworkMessaging Messaging
        {
            get { return TcgNetwork.Get().Messaging; }
        }

        public static GameClient Get()
        {
            return _instance;
        }
    }

    public class RefreshEvent
    {
        public ushort tag;
        public UnityAction<SerializedData> callback;
    }
}