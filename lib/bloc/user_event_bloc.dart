import 'package:open_git/bloc/event_bloc.dart';
import 'package:open_git/manager/event_manager.dart';

class UserEventBloc extends EventBloc {
  UserEventBloc(String userName) : super(userName);

  @override
  fetchEvent(int page) async {
    return await EventManager.instance.getEvent(userName, page);
  }

}
