#!/usr/bin/env python3
import argparse
import sys

from PyQt6.QtCore import Qt
from PyQt6.QtGui import QColor, QFont, QPainter
from PyQt6.QtWidgets import QApplication, QWidget

parser = argparse.ArgumentParser(
    description="screen coordinate selector",
    epilog="""Displays coordinates on the screen and prints the position of the one you type.
The coordinates can be tweaked with the arrow keys.""")
parser.add_argument('--color', type=QColor, default=QColor('red'))
parser.add_argument('--font')
parser.add_argument('--font-size', type=int, default=11)
parser.add_argument('--gap', type=int, default=30)
parser.add_argument('--margin', type=int, default=10)
args = parser.parse_args()
args.font = QFont(args.font if args.font else 'monospace', args.font_size, -1, False)

CHARS = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'

# The characters of the coordinate.
entered = []
# The coordinate shift set with the arrow keys.
offset = [0, 0]

# Coordinates go:
# aa ... az aA ... aZ a1a ... a1Z a2a ...
# ...
# za ... zz zA ... zZ z1a ... z1Z z2a ...
# Aa ... Az AA ... AZ A1a ... A1Z A2a ...
# ...
# Za ... Zz ZA ... ZZ Z1a ... Z1Z Z2a ...
# a1a ... a1z a1A ... a1Z a11a ... a11Z a12a ...
# ...

# Returns the x/y coordinate component, e.g. "j" or "1g".
def component(index):
    n = index // len(CHARS)
    c = CHARS[index % len(CHARS)]
    return (str(n) if n > 0 else "") + c

# Returns the x/y position of the x/y coordinate component.
def magnitude(comp):
    p = args.margin
    if len(comp) == 2:
        p += 52 * int(comp[0]) * args.gap
    if comp[-1].isupper():
        return p + (26 + ord(comp[-1]) - 65) * args.gap
    return p + (ord(comp[-1]) - 97) * args.gap

# Returns the position of the coordinate (such as "j1g"), e.g. (1750, 280).
def position(coord):
    if (len(coord) == 2 and coord[0].isalpha()):
        p = magnitude(coord[1]), magnitude(coord[0])
    elif len(coord) == 3:
        if coord[0].isalpha():
            p = magnitude(coord[1] + coord[2]), magnitude(coord[0])
        else:
            p = magnitude(coord[2]), magnitude(coord[0] + coord[1])
    elif len(coord) == 4:
        p = magnitude(coord[2] + coord[3]), magnitude(coord[0] + coord[1])
    return p[0] + offset[0], p[1] + offset[1]


class Window(QWidget):

    def __init__(self):
        super().__init__()
        self.setWindowFlags(
            Qt.WindowType.WindowStaysOnTopHint |
            Qt.WindowType.FramelessWindowHint
        )
        self.setAttribute(Qt.WidgetAttribute.WA_TranslucentBackground)

    def keyPressEvent(self, event):
        if event.key() == Qt.Key.Key_Escape:
            sys.exit(1)
        elif event.key() == Qt.Key.Key_Backspace and entered:
            entered.pop()
        elif event.key() == Qt.Key.Key_Left:
            offset[0] -= 10
            self.update()
        elif event.key() == Qt.Key.Key_Right:
            offset[0] += 10
            self.update()
        elif event.key() == Qt.Key.Key_Down:
            offset[1] += 10
            self.update()
        elif event.key() == Qt.Key.Key_Up:
            offset[1] -= 10
            self.update()

        try:
            c = chr(event.key())
        except ValueError:
            return

        if c.isalpha():
            entered.append(c if (event.modifiers() == Qt.KeyboardModifier.ShiftModifier) else c.lower())
            if (len(entered) == 2 and entered[0].isalpha()) or len(entered) > 2:
                monitor = self.window().windowHandle().screen().geometry().topLeft()
                x, y = position(entered)
                print(monitor.x() + x, monitor.y() + y)
                sys.exit()
        elif (len(entered) == 0 or entered[-1].isalpha()) and c.isdigit():
            entered.append(c)

    def paintEvent(self, event):
        qp = QPainter()
        qp.begin(self)
        self.draw(event, qp)
        qp.end()

    def draw(self, event, qp):
        qp.setFont(args.font)
        qp.setPen(args.color)
        qp.setBrush(args.color)
        width, height = self.frameSize().width(), self.frameSize().height()
        for i, y in enumerate(range(args.margin, height - args.margin, args.gap)):
            for j, x in enumerate(range(args.margin, width - args.margin, args.gap)):
                qp.drawRect(x - 2 + offset[0], y - 2 + offset[1], 2, 2)
                qp.drawText(x + offset[0], y + offset[1], 1234, 1234, Qt.AlignmentFlag.AlignTop, component(i) + component(j))


def main():
    app = QApplication(sys.argv)
    w = Window()
    w.showFullScreen()
    sys.exit(app.exec())

if __name__ == '__main__':
    main()
