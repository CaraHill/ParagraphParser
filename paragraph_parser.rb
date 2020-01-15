# frozen_string_literal: true

# This class parses a paragraph to return an array of its sentences.
class ParagraphParser
  def initialize(paragraph)
    @sentences = []
    @characters = paragraph.chars
  end

  def sentences
    @sentences << find_sentence(@characters) until @characters.empty?
    @sentences
  end

  private

  def find_sentence(array)
    index = array.index { |char| /[\.\?\!]/ =~ char }
    next_index = index + 1
    next_char = array[next_index]
    return get_sentence(array, next_index) if end_of_sentence?(next_char)

    get_difficult_sentence(array, index)
  end

  def get_sentence(array, next_index)
    array.slice!(0..next_index).join.strip.gsub(/\n/, ' ')
  end

  def end_of_sentence?(char)
    char.match?(/\s/)
  end

  def get_difficult_sentence(array, index)
    new_index = find_end_of_sentence(array, index)

    get_sentence(array, new_index)
  end

  def find_end_of_sentence(array, index)
    until end_of_sentence?(array[index])
      index = array[index..-1].index { |char| /[\.\"\?\!]/ =~ char } + index
      index += 1
    end

    index
  end
end
