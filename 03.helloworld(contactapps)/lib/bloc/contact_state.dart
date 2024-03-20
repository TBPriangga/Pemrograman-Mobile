import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../model/user.dart';

@immutable
abstract class ContactState extends Equatable {
  const ContactState();

  @override
  List<Object?> get props => [];
}

class ContactInitial extends ContactState {}

class ContactLoading extends ContactState {}

class ContactLoaded extends ContactState {
  final List<User> user;
  const ContactLoaded({required this.user});

  @override
  List<Object?> get props => [user];
}

class ContactFailed extends ContactState {}
