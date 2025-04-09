abstract class NewPostEvent {}

class LoadMediaEvent extends NewPostEvent {}

class SelectMediaEvent extends NewPostEvent {
  final int index;
  SelectMediaEvent(this.index);
}

class ChangeFilterEvent extends NewPostEvent {
  final String filter;
  ChangeFilterEvent(this.filter);
}

class ChangeFilterStrengthEvent extends NewPostEvent {
  final double strength;
  ChangeFilterStrengthEvent(this.strength);
}
