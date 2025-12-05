I want to add theme editing options for the user.
I have a reference for a other project that I have - use it for reference to build the color picker widget and the state. Note that the example uses bloc/cubit to manage state but you should convert this to riverpod since this is what we are using...

```dart

// The state

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit()
      : super(ThemeState.normal(
          colorValue: Colors.blueGrey.value,
          brightness: Brightness.light,
        ));

  void selectColor(Color color) {
    final newState = state.copyWith(
      colorValue: color.value,
    );
    emit(newState);
  }

  void selectBrightness(Brightness brightness) {
    final newState = state.copyWith(
      brightness: brightness,
    );
    emit(newState);
  }
}


// Theme selector

GridView.extent(
  shrinkWrap: true,
  maxCrossAxisExtent: 50,
  mainAxisSpacing: 8,
  crossAxisSpacing: 8,
  padding: EdgeInsets.zero,
  physics: const NeverScrollableScrollPhysics(),
  children: const <Color>[Colors.black, Colors.white]
      .followedBy(Colors.primaries.reversed)
      .followedBy(Colors.accents)
      .where(_removeBlackAndWhite)
      .map(ColorOption.fromColor)
      .toList(growable: false),
)

// Remove black colors

bool _removeBlackAndWhite(Color color) =>
    color != Colors.black && color != Colors.white;

```

Ps: The `ColorOption` is a widget to displaya color.
It has a constructor that receives the color; `ColorOption.fromColor`. Make the color in a cute way

Lets focus in awesome UI here.

Also create a beutiful ui for picking the bright as well - lets give support for dark mode. Please put a warning indicator in some part that will indicate that dark mode is still in beta and that in some places some colors might not be 100% good