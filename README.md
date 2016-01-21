# Friendly

Friendly is HTML and XML parser for Elixir aiming at friendly API.
 
Friendly was born out of frustration with Elixir APIs for HTML/XML parsing as of January 2016.

The package is a thin API layer on top of otherwise excellent [Floki](https://github.com/philss/floki).

Query the XML/HTML with a CSS selector, get the list of elements out.

## Usage

```elixir
Friendly.find(xml_string, css_selector)
```

Returns a List of elements:
```elixir
[element1, element2, element3, ...]
```

Each element is a Map:
```elixir
%{
  name: "ElementName",
  attributes: %{ "attr1" => "value1", "attr2" => "value2" },    # Map of attributes
  elements: [element1, element2, element3],       # List of children elements
  text: "Concatenated direct text content",
  texts: ["Text1", "Text2", "Text3"]              # List of children texts
}
```
The children elements are again Maps.

This makes it very natural to traverse.

Caveats:

* Attributes' names are BitStrings, not Atoms. This is because Atoms in Elixir and not GC-ed. We cannot allow them to be injected into VM by the untrusted XML.
  
* Attributes' names are __forced lowercase__, so iAmAttributeName becomes iamattributename. Unfortunately this is how underlying Floki works. Hopefully this will get fixed eventually.

## Example

```elixir
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
```

## Installation

The package is [available in Hex](https://hex.pm/packages/friendly). To install:

  1. Add friendly to your list of dependencies in `mix.exs`:

        def deps do
          [{:friendly, "~> 1.0.0"}]
        end

  2. Ensure friendly is started before your application:

        def application do
          [applications: [:friendly]]
        end
