# frozen_string_literal: true

# This class parses a paragraph to return an array of its sentences.
class ParagraphParser
  def initialize(paragraph)
    @sentences = []
    @characters = paragraph.chars
  end

  def find_sentences
    @sentences << find_sentence(@characters) until @characters.empty?
    @sentences
  end

  private

  def find_sentence(array)
    index = find_end_of_sentence(array)
    next_index = index + 1
    next_char = array[next_index]
    return get_sentence(array, next_index) if end_of_sentence?(next_char)

    find_proper_end_of_sentence(array, index)
  end

  def find_end_of_sentence(array)
    array.find_index('.')
  end

  def get_sentence(array, next_index)
    array.slice!(0..next_index).join.strip.gsub(/\n/, ' ')
  end

  def find_proper_end_of_sentence(array, index)
    new_index = index

    until end_of_sentence?(array[new_index])
      new_index = array[new_index..-1].find_index('.') + new_index
      new_index += 1
    end

    get_sentence(array, new_index) if end_of_sentence?(array[new_index])
  end

  def end_of_sentence?(char)
    char.match?(/\s/)
  end
end
