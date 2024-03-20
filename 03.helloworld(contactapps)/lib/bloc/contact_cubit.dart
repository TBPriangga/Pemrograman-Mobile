import 'package:bloc/bloc.dart';
import '../../model/user.dart';
import 'contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  ContactCubit() : super(ContactInitial());

  List<User> user = [];

  void addContact({required String username, required int number}) {
    emit(ContactInitial());
    user.add(User(name: username, number: number));
    emit(ContactLoading());
    Future.delayed(
        const Duration(seconds: 3), () => emit(ContactLoaded(user: user)));
  }

  void removeUser({required int index}) {
    emit(ContactInitial());
    user.removeAt(index);
    if (user.isEmpty) {
      emit(ContactInitial());
    } else {
      emit(ContactLoaded(user: user));
    }
  }
}
