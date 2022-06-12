import 'package:jaspr/jaspr.dart';
import 'package:jaspr_ui/bootstrap.dart';
import 'package:jaspr_ui/core.dart';

class GridSystemPage extends StatelessComponent {
  static String style = '''
        .content {
          padding: 10px;
          font-size: 32px;
          font-weight: bold;
          text-align: center;
          background: #dbdfe5;
        }
      ''';

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield HorizontalLine();
    // Two column layout
    yield Container(
      children: [
        Row(children: [
          Column(
            flex: Flex(
              breakpoint: Breakpoint.medium,
              space: ColumnSpace.s6,
            ),
            child: Container(
              child: Text("Column left"),
              padding: EdgeInsets.all(Space.s3),
              margin: EdgeInsets.symmetric(vertical: Space.s2),
              styles: {'background': '#dbdfe5'},
            ),
          ),
          Column(
            flex: Flex(
              breakpoint: Breakpoint.medium,
              space: ColumnSpace.s6,
            ),
            child: Container(
              child: Text("Column right"),
              padding: EdgeInsets.all(Space.s3),
              margin: EdgeInsets.symmetric(vertical: Space.s2),
              styles: {'background': '#abb1b8'},
            ),
          )
        ]),
      ],
    );
    yield Container(
      children: [
        Row(children: [
          Column(
            flex: Flex(
              breakpoint: Breakpoint.medium,
              space: ColumnSpace.s4,
            ),
            child: Container(
              child: Text("Column left"),
              padding: EdgeInsets.all(Space.s3),
              margin: EdgeInsets.symmetric(vertical: Space.s2),
              styles: {'background': '#dbdfe5'},
            ),
          ),
          Column(
            flex: Flex(
              breakpoint: Breakpoint.medium,
              space: ColumnSpace.s8,
            ),
            child: Container(
              child: Text("Column right"),
              padding: EdgeInsets.all(Space.s3),
              margin: EdgeInsets.symmetric(vertical: Space.s2),
              styles: {'background': '#abb1b8'},
            ),
          )
        ]),
      ],
    );
    yield Container(
      children: [
        Row(children: [
          Column(
            flex: Flex(
              breakpoint: Breakpoint.medium,
              space: ColumnSpace.s3,
            ),
            child: Container(
              child: Text("Column left"),
              padding: EdgeInsets.all(Space.s3),
              margin: EdgeInsets.symmetric(vertical: Space.s2),
              styles: {'background': '#dbdfe5'},
            ),
          ),
          Column(
            flex: Flex(
              breakpoint: Breakpoint.medium,
              space: ColumnSpace.s9,
            ),
            child: Container(
              child: Text("Column right"),
              padding: EdgeInsets.all(Space.s3),
              margin: EdgeInsets.symmetric(vertical: Space.s2),
              styles: {'background': '#abb1b8'},
            ),
          )
        ]),
      ],
    );
    yield HorizontalLine();
    // Three column layout
    yield Container(
      children: [
        Row(children: [
          Column(
            flex: Flex(
              breakpoint: Breakpoint.medium,
              space: ColumnSpace.s4,
            ),
            child: Container(
              child: Text("Column left"),
              padding: EdgeInsets.all(Space.s3),
              margin: EdgeInsets.symmetric(vertical: Space.s2),
              styles: {'background': '#dbdfe5'},
            ),
          ),
          Column(
            flex: Flex(
              breakpoint: Breakpoint.medium,
              space: ColumnSpace.s4,
            ),
            child: Container(
              child: Text("Column middle"),
              padding: EdgeInsets.all(Space.s3),
              margin: EdgeInsets.symmetric(vertical: Space.s2),
              styles: {'background': '#abb1b8'},
            ),
          ),
          Column(
            flex: Flex(
              breakpoint: Breakpoint.medium,
              space: ColumnSpace.s4,
            ),
            child: Container(
              child: Text("Column right"),
              padding: EdgeInsets.all(Space.s3),
              margin: EdgeInsets.symmetric(vertical: Space.s2),
              styles: {'background': '#dbdfe5'},
            ),
          )
        ]),
      ],
    );
    yield Container(
      children: [
        Row(children: [
          Column(
            flex: Flex(
              breakpoint: Breakpoint.medium,
              space: ColumnSpace.s2,
            ),
            child: Container(
              child: Text("Column left"),
              padding: EdgeInsets.all(Space.s3),
              margin: EdgeInsets.symmetric(vertical: Space.s2),
              styles: {'background': '#dbdfe5'},
            ),
          ),
          Column(
            flex: Flex(
              breakpoint: Breakpoint.medium,
              space: ColumnSpace.s8,
            ),
            child: Container(
              child: Text("Column middle"),
              padding: EdgeInsets.all(Space.s3),
              margin: EdgeInsets.symmetric(vertical: Space.s2),
              styles: {'background': '#abb1b8'},
            ),
          ),
          Column(
            flex: Flex(
              breakpoint: Breakpoint.medium,
              space: ColumnSpace.s2,
            ),
            child: Container(
              child: Text("Column right"),
              padding: EdgeInsets.all(Space.s3),
              margin: EdgeInsets.symmetric(vertical: Space.s2),
              styles: {'background': '#dbdfe5'},
            ),
          )
        ]),
      ],
    );
    yield Container(
      children: [
        Row(children: [
          Column(
            flex: Flex(
              breakpoint: Breakpoint.medium,
              space: ColumnSpace.s3,
            ),
            child: Container(
              child: Text("Column left"),
              padding: EdgeInsets.all(Space.s3),
              margin: EdgeInsets.symmetric(vertical: Space.s2),
              styles: {'background': '#dbdfe5'},
            ),
          ),
          Column(
            flex: Flex(
              breakpoint: Breakpoint.medium,
              space: ColumnSpace.s7,
            ),
            child: Container(
              child: Text("Column middle"),
              padding: EdgeInsets.all(Space.s3),
              margin: EdgeInsets.symmetric(vertical: Space.s2),
              styles: {'background': '#abb1b8'},
            ),
          ),
          Column(
            flex: Flex(
              breakpoint: Breakpoint.medium,
              space: ColumnSpace.s2,
            ),
            child: Container(
              child: Text("Column right"),
              padding: EdgeInsets.all(Space.s3),
              margin: EdgeInsets.symmetric(vertical: Space.s2),
              styles: {'background': '#dbdfe5'},
            ),
          )
        ]),
      ],
    );
    yield HorizontalLine();
    // Auto-layout columns
    yield Container(
      children: [
        Row(children: [
          Column(
            child: Container(
              child: Text("Column left"),
              padding: EdgeInsets.all(Space.s3),
              margin: EdgeInsets.symmetric(vertical: Space.s2),
              styles: {'background': '#dbdfe5'},
            ),
          ),
          Column(
            child: Container(
              child: Text("Column right"),
              padding: EdgeInsets.all(Space.s3),
              margin: EdgeInsets.symmetric(vertical: Space.s2),
              styles: {'background': '#abb1b8'},
            ),
          ),
        ]),
      ],
    );
    yield Container(
      children: [
        Row(children: [
          Column(
            child: Container(
              child: Text("Column left"),
              padding: EdgeInsets.all(Space.s3),
              margin: EdgeInsets.symmetric(vertical: Space.s2),
              styles: {'background': '#dbdfe5'},
            ),
          ),
          Column(
            child: Container(
              child: Text("Column middle"),
              padding: EdgeInsets.all(Space.s3),
              margin: EdgeInsets.symmetric(vertical: Space.s2),
              styles: {'background': '#abb1b8'},
            ),
          ),
          Column(
            child: Container(
              child: Text("Column right"),
              padding: EdgeInsets.all(Space.s3),
              margin: EdgeInsets.symmetric(vertical: Space.s2),
              styles: {'background': '#dbdfe5'},
            ),
          )
        ]),
      ],
    );
    yield Container(
      children: [
        Row(children: [
          Column(
            child: Container(
              child: Text("Column left"),
              padding: EdgeInsets.all(Space.s3),
              margin: EdgeInsets.symmetric(vertical: Space.s2),
              styles: {'background': '#dbdfe5'},
            ),
          ),
          Column(
            flex: Flex(
              breakpoint: Breakpoint.medium,
              space: ColumnSpace.s6,
            ),
            child: Container(
              child: Text("Column middle"),
              padding: EdgeInsets.all(Space.s3),
              margin: EdgeInsets.symmetric(vertical: Space.s2),
              styles: {'background': '#abb1b8'},
            ),
          ),
          Column(
            child: Container(
              child: Text("Column right"),
              padding: EdgeInsets.all(Space.s3),
              margin: EdgeInsets.symmetric(vertical: Space.s2),
              styles: {'background': '#dbdfe5'},
            ),
          )
        ]),
      ],
    );
    yield HorizontalLine();
    // Column Wrapping Behavior
    yield Container(
      children: [
        Row(children: [
          Column(
            flexibility: [
              Flex(
                breakpoint: Breakpoint.medium,
                space: ColumnSpace.s4,
              ),
              Flex(
                breakpoint: Breakpoint.large,
                space: ColumnSpace.s3,
              ),
            ],
            child: Container(
              child: Text("Column left"),
              padding: EdgeInsets.all(Space.s3),
              margin: EdgeInsets.symmetric(vertical: Space.s2),
              styles: {'background': '#dbdfe5'},
            ),
          ),
          Column(
            flexibility: [
              Flex(
                breakpoint: Breakpoint.medium,
                space: ColumnSpace.s8,
              ),
              Flex(
                breakpoint: Breakpoint.large,
                space: ColumnSpace.s6,
              ),
            ],
            child: Container(
              child: Text("Column middle"),
              padding: EdgeInsets.all(Space.s3),
              margin: EdgeInsets.symmetric(vertical: Space.s2),
              styles: {'background': '#abb1b8'},
            ),
          ),
          Column(
            flexibility: [
              Flex(
                breakpoint: Breakpoint.medium,
                space: ColumnSpace.s12,
              ),
              Flex(
                breakpoint: Breakpoint.large,
                space: ColumnSpace.s3,
              ),
            ],
            child: Container(
              child: Text("Column right"),
              padding: EdgeInsets.all(Space.s3),
              margin: EdgeInsets.symmetric(vertical: Space.s2),
              styles: {'background': '#dbdfe5'},
            ),
          )
        ]),
      ],
    );
    yield HorizontalLine();
    yield Container(
      breakpoint: Breakpoint.large,
      child: Row(children: [
        for (var i = 1; i <= 12; i++)
          Column(
            flexibility: [
              Flex(
                breakpoint: Breakpoint.medium,
                space: ColumnSpace.s6,
              ),
              Flex(
                breakpoint: Breakpoint.large,
                space: ColumnSpace.s4,
              ),
              Flex(
                breakpoint: Breakpoint.extraLarge,
                space: ColumnSpace.s3,
              )
            ],
            child: Paragraph(
              "Box $i",
              classes: ['content'],
            ),
          )
      ]),
    );
    yield HorizontalLine();
  }
}