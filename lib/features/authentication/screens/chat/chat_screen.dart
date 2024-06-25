import 'package:app_health_connect/config/constants/constantes.dart';
import 'package:app_health_connect/config/constants/environment.dart';
import 'package:app_health_connect/config/helper/logging.dart';
import 'package:app_health_connect/features/authentication/controllers/chat/chat_controller.dart';
import 'package:app_health_connect/features/authentication/screens/chat/widgets/chat_widgets.dart';
import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:app_health_connect/utils/constants/text_strings.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatelessWidget {
  static const name = 'chat-screen';

  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: _ChatView()
        // bottomNavigationBar: CustomBottomNavigation(),
        );
  }
}

class _ChatView extends StatefulWidget {
  const _ChatView();

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  final _log = logger(_ChatView);
  final _openAiKey = Environment.openAiKey;
  //final ChatUser _user =ChatUser(id: '1', firstName: "Luis", lastName: 'Natividad');
  final ChatUser _asistenteVirtual = ChatUser(
      id: '2',
      firstName: 'Health',
      lastName: 'Connect',
      profileImage: 'assets/images/logo.png');
  List<ChatMessage> _messages = <ChatMessage>[];
  final List<ChatUser> _typingUsers = <ChatUser>[];

  final controller = Get.put(ChatController());
  bool _historialCargado = false;
  late ChatUser _user;
  @override
  void initState() {
    _log.i('Inicializar Pantalla');
    super.initState();
    // cargarHistorial();
    _user = ChatUser(id: '1', firstName: controller.nombreUsuario);
  }

  void cargarHistorial() {
    if (_historialCargado) return;

    List<ChatMessage> historial = controller.messagesHistory.reversed.map((m) {
      if (m['role'] == 'user') {
        return ChatMessage(
          user: _user,
          text: m['content'],
          createdAt: DateTime.now(), // Ajustar según sea necesario
        );
      } else {
        return ChatMessage(
          user: _asistenteVirtual,
          text: m['content'],
          createdAt: DateTime.now(), // Ajustar según sea necesario
        );
      }
    }).toList();

    //setState(() {
    _messages.addAll(historial);
    _historialCargado = true;
    //});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromRGBO(65, 87, 255, 1),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              showCustomDialogSaveChat(context,controller);
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 40,
                height: 40,
              ),
              const SizedBox(width: 3),
              const Text(
                'Health Connect',
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: () {
                showCustomDialogRemoveChat(context,controller);
              },
            )
          ]

          /*
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25)
          )
        ),
        */
          ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
            if (controller.messagesHistory.isEmpty) {
              _messages = <ChatMessage>[];
              _messages.add(
                ChatMessage(
                    text:
                        'Hola ${controller.nombreUsuario ?? ''}, ¿Cómo estás? \n¿Hay algo en lo que pueda ayudarte o que te gustaría hablar? 😃',
                    user: _asistenteVirtual,
                    createdAt: DateTime.now()),
              );
            }
          cargarHistorial();
          return DashChat(
              currentUser: _user,
              inputOptions: const InputOptions(
                  alwaysShowSend: true,
                  cursorStyle: CursorStyle(color: Colors.black)),
              messageOptions: const MessageOptions(
                currentUserContainerColor: Color.fromARGB(255, 232, 232, 232),
                currentUserTextColor: Colors.black,
                containerColor: Color.fromRGBO(65, 87, 255, 1),
                textColor: Colors.white,
                showTime: true,
              ),
              messageListOptions: const MessageListOptions(
                  separatorFrequency: SeparatorFrequency.hours,
                  scrollPhysics: ClampingScrollPhysics()),
              onSend: (ChatMessage m) {
                getChatResponse(m);
              },
              messages: _messages,
              typingUsers: _typingUsers);
        }
      }),
    );
  }

  Future<void> getChatResponse(ChatMessage m) async {
    setState(() {
      _messages.insert(0, m);
      _typingUsers.add(_asistenteVirtual);
    });
    //controller.messagesHistory =
    List<Map<String, dynamic>> messagesHistory =
        _messages.reversed.toList().map((m) {
      if (m.user == _user) {
        return Messages(role: Role.user, content: m.text).toJson();
      } else {
        return Messages(role: Role.assistant, content: m.text).toJson();
      }
    }).toList();

    controller.messagesHistory.insert(
        0, Messages(role: Role.system, content: promptAssistant).toJson());

    controller.messagesHistory.assignAll(messagesHistory);

    final request = ChatCompleteText(
        messages: controller.messagesHistory,
        maxToken: 200,
        temperature: 0.7,
        model: GptTurbo0125ChatModel());

    try {
      _log.d('OpenAIKey: $_openAiKey');
      final openAI = OpenAI.instance.build(
          token: _openAiKey,
          baseOption: HttpSetup(
            receiveTimeout: const Duration(seconds: 5),
          ),
          enableLog: true);

      final response = await openAI.onChatCompletion(request: request);
      _log.d('response: $response');
      String fullResponse = '';
      if (response != null && response.choices.isNotEmpty) {
        fullResponse = response.choices.first.message?.content ?? '';
        controller.messagesHistory.add(
            Messages(role: Role.assistant, content: fullResponse).toJson());

        //Simular escritura línea por línea
        simulateTyping(fullResponse);
      }
    } catch (e) {
      _log.e('Error al obtener Respuesta: $e');
      setState(() {
        _messages.insert(
            0,
            ChatMessage(
                user: _asistenteVirtual,
                createdAt: DateTime.now(),
                text: msgError1));
      });
    } finally {
      _log.i('Finally: Removiendo typing user');
      setState(() {
        _typingUsers.remove(_asistenteVirtual);
      });
    }
  }

  void simulateTyping(String fullResponse) async {
    String currentText = '';
    const messageIndex = 0;
    _log.i(fullResponse);
    _messages.insert(
      messageIndex,
      ChatMessage(
        user: _asistenteVirtual,
        createdAt: DateTime.now(),
        text: currentText,
        customProperties: {'isTyping': true},
      ),
    );

    for (int i = 0; i < fullResponse.length; i++) {
      currentText += fullResponse[i];
      //_log.i(currentText);
      setState(() {
        _messages[messageIndex] = ChatMessage(
          user: _asistenteVirtual,
          createdAt: _messages[messageIndex].createdAt,
          text: currentText,
          customProperties: {'isTyping': true},
        );
      });
      await Future.delayed(const Duration(milliseconds: 5));
    }

    setState(() {
      _messages[messageIndex] = ChatMessage(
        user: _asistenteVirtual,
        createdAt: _messages[messageIndex].createdAt,
        text: currentText,
        customProperties: {'isTyping': false},
      );
    });
  }
}
