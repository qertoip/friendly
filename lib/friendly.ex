defmodule Friendly do

  def find(xml_string, css_selector) do
    Floki.find(xml_string, css_selector)
    |> to_elements
  end

  defp to_elements(flok_elms) do
    Enum.map(flok_elms, &to_element/1)
  end

  defp to_element(flok_elm) do
    children = fetch_children(flok_elm)
    { elements, texts } = Enum.partition(children, &(is_map(&1)))
    text = Enum.join(texts, " ")
    %{
      name: fetch_name(flok_elm),
      attributes: fetch_attributes(flok_elm),
      elements: elements,
      texts: texts,
      text: text
    }
  end

  defp fetch_name(elm_tuple) do
    elem(elm_tuple, 0)
  end

  defp fetch_attributes(elm_tuple) do
    Enum.into(Enum.map(elem(elm_tuple, 1), fn key_value_tuple ->
      { attr_name, attr_value } = key_value_tuple
      #attr_name = String.to_atom(attr_name)
      { attr_name, attr_value }
    end), %{})
  end

  defp fetch_children(elm_tuple) do
    children = elem(elm_tuple, 2)
    Enum.map(children, fn child ->
      if is_tuple(child) do
        to_element(child)
      else
        child # text
      end
    end)
  end

end
