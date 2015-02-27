class Game < ActiveRecord::Base
  scope :page, ->(page, per_page = 25) do
    page_offset = (page - 1) * per_page
    offset(page_offset).limit(per_page)
  end

  def title
    super || ""
  end

  def developer
    super || ""
  end

  def publisher
    super || ""
  end

  def serializable_hash(options = {})
    {
      id: id,
      title: title,
      developer: developer || "",
      publisher: publisher,
      released_on: released_on,
    }
  end
end
