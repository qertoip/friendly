defmodule FriendlyTest do
  use ExUnit.Case

  test "Non-matching selector" do
    xml = String.trim("""
      <?xml version="1.0" encoding="UTF-8"?>
      <root/>
    """)
    elements = Friendly.find(xml, "non-matching selector")
    assert(is_list(elements))
    assert(Enum.empty?(elements))
  end

  test "Single empty element" do
    xml = String.trim("""
      <?xml version="1.0" encoding="UTF-8"?>
      <root/>
    """)
    elements = Friendly.find(xml, "root")
    assert(Enum.count(elements) == 1)
    root = hd(elements)
    assert(root.name == "root")
    assert(root.attributes == %{})
    assert(root.text == "")
  end

  test "Single empty element with attributes" do
    xml = String.trim("""
      <?xml version="1.0" encoding="UTF-8"?>
      <root id="2" iAmCamelCased="iAmCamelCased" some_attr="some attr" data-attr="ĄĆĘŁŃÓŚŻŹ" i-AM-Strange="strange" />
    """)
    elements = Friendly.find(xml, "root")
    assert(Enum.count(elements) == 1)
    root = hd(elements)
    assert(root.name == "root")
    assert(root.attributes == %{
      "id" => "2",
      "iamcamelcased" => "iAmCamelCased",
      "some_attr" => "some attr",
      "data-attr" => "ĄĆĘŁŃÓŚŻŹ",
      "i-am-strange" => "strange"
    })
    assert(root.text == "")
  end

  test "Single element with text" do
    xml = String.trim("""
      <?xml version="1.0" encoding="UTF-8"?>
      <root> \t I am some text in first line.\nI should be in the second line.\nAnd me in the third. \t </root>
    """)
    elements = Friendly.find(xml, "root")
    assert(Enum.count(elements) == 1)
    root = hd(elements)
    assert(root.name == "root")
    assert(root.attributes == %{})
    assert(root.text == " \t I am some text in first line.\nI should be in the second line.\nAnd me in the third. \t ")
  end

  test "Nested single element with atributes and text" do
    xml = String.trim("""
      <?xml version="1.0" encoding="UTF-8"?>
      <root>
        XXXXX1
        <target name="Sporitelna_cz">
          yyyyy2
        </target>
        wwwww3
      </root>
    """)
    elements = Friendly.find(xml, "target")
    assert(Enum.count(elements) == 1)
    target = hd(elements)
    assert(target.name == "target")
    assert(target.attributes["name"] == "Sporitelna_cz")
    assert(String.trim(target.text) == "yyyyy2")
  end

  test "Multiple nested elements" do
    xml = String.trim("""
      <?xml version="1.0" encoding="UTF-8"?>
      <root>
        XXXXX1
        <target name="Sporitelna_cz">
          yyyyy2.1
          <command id="c1"></command>
          yyyyy2.2
          <command id="c2">UU</command>
          yyyyy2.3
        </target>
        wwwww3
      </root>
    """)
    elements = Friendly.find(xml, "command")
    assert(Enum.count(elements) == 2)
    [c1, c2] = elements
    assert(c1.name == "command")
    assert(c2.name == "command")
    assert(c1.attributes["id"] == "c1")
    assert(c2.attributes["id"] == "c2")
    assert(String.trim(c1.text) == "")
    assert(String.trim(c2.text) == "UU")
  end

  test "Multiple text nodes" do
    xml = String.trim("""
      <?xml version="1.0" encoding="UTF-8"?>
      <root>
        XXXXX1
        <target name="Sporitelna_cz">
          yyyyy2.1
          <command id="c1"></command>
          yyyyy2.2
          <command id="c2"></command>
          yyyyy2.3
        </target>
        wwwww3
      </root>
    """)
    elements = Friendly.find(xml, "target")
    assert(Enum.count(elements) == 1)
    target = hd(elements)
    assert(String.trim(target.text) =~ "yyyyy2.1")
    assert(String.trim(target.text) =~ "yyyyy2.2")
    assert(String.trim(target.text) =~ "yyyyy2.3")
    assert(Enum.count(target.texts) == 3)
  end

  @tag :skip
  test "Readme Example" do
    xml = """
<?xml version="1.0"?>
<catalog>
  <book id="bk101">
     <author>Gambardella, Matthew</author>
     <title>XML Developer's Guide</title>
     <genre>Computer</genre>
     <price>44.95</price>
     <publish_date>2000-10-01</publish_date>
     <description>An in-depth look at creating applications
     with XML.</description>
  </book>
  <book id="bk102">
     <author>Ralls, Kim</author>
     <title>Midnight Rain</title>
     <genre>Fantasy</genre>
     <price>5.95</price>
     <publish_date>2000-12-16</publish_date>
     <description>A former architect battles corporate zombies,
     an evil sorceress, and her own childhood to become queen
     of the world.</description>
  </book>
</catalog>
    """

    books = Friendly.find(xml, "book")

    Enum.each(books, fn book ->
      id = book.attributes["id"]
      IO.puts("Book [#{id}]")

      title = Enum.find(book.elements, fn elm -> elm.name == "title" end)
      IO.puts("\ttitle: #{title.text}")

      author = Enum.find(book.elements, fn elm -> elm.name == "author" end)
      IO.puts("\tauthor: #{author.text}")
    end)
  end

end
