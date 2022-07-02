import 'package:jaspr/jaspr.dart';
import 'package:jaspr/ui.dart';

class FirstPage extends StatelessComponent {
  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield DivElement(
      classes: ['container'],
      child: DivElement(
        classes: ['row'],
        children: [
          Paragraph(child: Text("Hello world!!")),
          Center(child: ButtonElement(text: "test123")),
          Size(height: Pixels(50)),
          DivElement(
            children: [
              ButtonElement(text: "test123"),
              ButtonElement(text: "test123", style: BackgroundStyle(color: Color.fromName(Colors.lightBlue))),
              ButtonElement(text: "test123", style: ColorStyle(Color.fromName(Colors.hotPink))),
            ],
          ),
          Size(height: Pixels(50)),
          Center(
            child: Image(
              source: "https://metacode.biz/@test/avatar.jpg",
              alternate: "Test image",
            ),
          ),
          Link(
            href: "https://www.google.com/",
            target: LinkTarget.blank,
            child: Text("Google link"),
          ),
          Center(
            child: Size(
              width: Pixels(200),
              child: ListView(
                //insideMarkers: true,
                  style: MultipleStyle(styles: [
                    BackgroundStyle(color: Color.fromName(Colors.greenYellow)),
                    TextStyle(align: TextAlign.left)
                  ]),
                  ordered: true,
                  children: [
                    ListItem(child: Size(height: Pixels(50), width: Pixels(50), child: Text("test1"))),
                    ListItem(child: Text("test2")),
                    ListItem(child: Text("test3")),
                    ListItem(child: Text("test4")),
                  ]),
            ),
          )
        ],
      ),
    );
  }
}
