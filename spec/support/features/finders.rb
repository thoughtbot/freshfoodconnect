module Features
  include ActionView::RecordIdentifier

  def within_role(role, &block)
    within(%{[data-role="#{role}"]}, &block)
  end

  def within_record(record, &block)
    within("##{dom_id(record)}", &block)
  end
end
