import 'package:goat/data/session.dart';
import 'package:goat/data/_request.dart';

enum PageType { broadcast, person, group }

class Data {
  static PageType pageType = PageType.broadcast;
  static int selectedId = 0;
  static String selectedName = "";

  static getChats() => request({
        "q": "get_chats",
        "p": pageType.name,
        "user_id": Session.userId.toString(),
      });

  static getMessages() => request({
        "q": "get_messages",
        "p": pageType.name,
        "user_id": Session.userId.toString(),
        "selected_id": selectedId.toString(),
      });

  static sendMessage(String message) => request({
        "q": "send_message",
        "p": pageType.name,
        "user_id": Session.userId.toString(),
        "selected_id": selectedId.toString(),
        "text": message,
      });

  static create(String name, String ids) => request({
        "q": "create",
        "p": pageType.name,
        "user_id": Session.userId.toString(),
        "ids": ids,
        "name": name,
      });

  static getContacts() => request({
        "q": "get_contacts",
        "user_id": Session.userId.toString(),
      });

  static getSettings() => request({
        "q": "get_settings",
        "p": pageType.name,
        "user_id": Session.userId.toString(),
        "selected_id": selectedId.toString(),
      });

  static blockUser() => request({
        "q": "block_user",
        "user_id": Session.userId.toString(),
        "selected_id": selectedId.toString(),
      });

  static unblockUser() => request({
        "q": "unblock_user",
        "user_id": Session.userId.toString(),
        "selected_id": selectedId.toString(),
      });

  static deleteChat() => request({
        "q": "delete_chat",
        "p": pageType.name,
        "user_id": Session.userId.toString(),
        "selected_id": selectedId.toString(),
      });

  static delete() => request({
        "q": "delete",
        "p": pageType.name,
        "selected_id": selectedId.toString(),
      });

  static leaveGroup() => request({
        "q": "leave_group",
        "user_id": Session.userId.toString(),
        "selected_id": selectedId.toString(),
      });

  static updateGroupName(String name) => request({
        "q": "update_group_name",
        "name": name,
        "selected_id": selectedId.toString(),
      });
}
