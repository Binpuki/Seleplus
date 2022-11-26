package controls;

import lime.ui.GamepadButton;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;
import lime.ui.KeyModifier;
import lime.ui.KeyCode;

// i stole this from a custom fnf egninge of mine :)
class Converter
{
    public static function fromKeyCodeToFlxKey(key:KeyCode, modifier:KeyModifier) // I am SO sorry this is so fucking long - Binpuki
	{
		switch (key)
		{
			case UNKNOWN:
				return FlxKey.NONE;
			case A:
				return FlxKey.A;
			case B:
				return FlxKey.B;
			case C:
				return FlxKey.C;
			case D:
				return FlxKey.D;
			case E:
				return FlxKey.E;
			case F:
				return FlxKey.F;
			case G:
				return FlxKey.G;
			case H:
				return FlxKey.H;
			case I:
				return FlxKey.I;
			case J:
				return FlxKey.J;
			case K:
				return FlxKey.K;
			case L:
				return FlxKey.L;
			case M:
				return FlxKey.M;
			case N:
				return FlxKey.N;
			case O:
				return FlxKey.O;
			case P:
				return FlxKey.P;
			case Q:
				return FlxKey.Q;
			case R:
				return FlxKey.R;
			case S:
				return FlxKey.S;
			case T:
				return FlxKey.T;
			case U:
				return FlxKey.U;
			case V:
				return FlxKey.V;
			case W:
				return FlxKey.W;
			case X:
				return FlxKey.X;
			case Y:
				return FlxKey.Y;
			case Z:
				return FlxKey.Z;
			case NUMBER_0:
				return FlxKey.ZERO;
			case NUMBER_1:
				return FlxKey.ONE;
			case NUMBER_2:
				return FlxKey.TWO;
			case NUMBER_3:
				return FlxKey.THREE;
			case NUMBER_4:
				return FlxKey.FOUR;
			case NUMBER_5:
				return FlxKey.FIVE;
			case NUMBER_6:
				return FlxKey.SIX;
			case NUMBER_7:
				return FlxKey.SEVEN;
			case NUMBER_8:
				return FlxKey.EIGHT;
			case NUMBER_9:
				return FlxKey.NINE;
			case PAGE_UP:
				return FlxKey.PAGEUP;
			case PAGE_DOWN:
				return FlxKey.PAGEDOWN;
			case HOME:
				return FlxKey.HOME;
			case END:
				return FlxKey.END;
			case INSERT:
				return FlxKey.INSERT;
			case ESCAPE:
				return FlxKey.ESCAPE;
			case MINUS:
				return FlxKey.MINUS;
			case PLUS:
				return FlxKey.PLUS;
			case DELETE:
				return FlxKey.DELETE;
			case BACKSPACE:
				return FlxKey.BACKSPACE;
			case LEFT_BRACKET:
				return FlxKey.LBRACKET;
			case RIGHT_BRACKET:
				return FlxKey.RBRACKET;
			case BACKSLASH:
				return FlxKey.BACKSLASH;
			case CAPS_LOCK:
				return FlxKey.CAPSLOCK;
			case SEMICOLON:
				return FlxKey.SEMICOLON;
			case QUOTE:
				return FlxKey.QUOTE;
			case RETURN:
				return FlxKey.ENTER;
			case COMMA:
				return FlxKey.COMMA;
			case PERIOD:
				return FlxKey.PERIOD;
			case SLASH:
				return FlxKey.SLASH;
			case GRAVE:
				return FlxKey.GRAVEACCENT;
			case SPACE:
				return FlxKey.SPACE;
			case UP:
				return FlxKey.UP;
			case DOWN:
				return FlxKey.DOWN;
			case LEFT:
				return FlxKey.LEFT;
			case RIGHT:
				return FlxKey.RIGHT;
			case TAB:
				return FlxKey.TAB;
			case PRINT_SCREEN:
				return FlxKey.PRINTSCREEN;
			case F1:
				return FlxKey.F1;
			case F2:
				return FlxKey.F2;
			case F3:
				return FlxKey.F3;
			case F4:
				return FlxKey.F4;
			case F5:
				return FlxKey.F5;
			case F6:
				return FlxKey.F6;
			case F7:
				return FlxKey.F7;
			case F8:
				return FlxKey.F8;
			case F9:
				return FlxKey.F9;
			case F10:
				return FlxKey.F10;
			case F11:
				return FlxKey.F11;
			case F12:
				return FlxKey.F12;
			case NUMPAD_0:
				return FlxKey.NUMPADZERO;
			case NUMPAD_1:
				return FlxKey.NUMPADONE;
			case NUMPAD_2:
				return FlxKey.NUMPADTWO;
			case NUMPAD_3:
				return FlxKey.NUMPADTHREE;
			case NUMPAD_4:
				return FlxKey.NUMPADFOUR;
			case NUMPAD_5:
				return FlxKey.NUMPADFIVE;
			case NUMPAD_6:
				return FlxKey.NUMPADSIX;
			case NUMPAD_7:
				return FlxKey.NUMPADSEVEN;
			case NUMPAD_8:
				return FlxKey.NUMPADEIGHT;
			case NUMPAD_9:
				return FlxKey.NUMPADNINE;
			case NUMPAD_MINUS:
				return FlxKey.NUMPADMINUS;
			case NUMPAD_PLUS:
				return FlxKey.NUMPADPLUS;
			case NUMPAD_PERIOD:
				return FlxKey.NUMPADPERIOD;
			case NUMPAD_MULTIPLY:
				return FlxKey.NUMPADMULTIPLY;
			default:
				return fromKeyModifierToFlxKey(modifier);
		}

		return FlxKey.NONE;
	}

	static function fromKeyModifierToFlxKey(modif:KeyModifier):FlxKey
	{
		if (modif.shiftKey)
			return FlxKey.SHIFT;
		if (modif.ctrlKey)
			return FlxKey.CONTROL;
		if (modif.altKey)
			return FlxKey.ALT;

		return FlxKey.NONE;
	}

	public static function fromFlxGamepadToGamepadButton(button:FlxGamepadInputID):GamepadButton
	{
		return cast(button, GamepadButton);
	}
}