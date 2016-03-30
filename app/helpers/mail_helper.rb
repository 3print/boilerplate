module MailHelper
  def table_attrs
    {
      border: 0,
      cellpadding: 0,
      cellspacing: 0,
    }
  end

  def inner_table_attrs
    table_attrs.merge(width: '100%')
  end

  def background_white
    { background: 'white' }
  end

  def grey_box
    {
      style: styles({
        background: '#efefef',
        border: '1px solid #b4b4b6',
        padding: '10px',
        width: '50%',
        margin: '0 auto 40px'
      })
    }
  end
end
