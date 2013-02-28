require 'test_helper'

class TranslationHelperTest < ActionView::TestCase
  setup do
    @document = stub('document', display_type_key: 'stub')
  end

  test "#t_display_type translates document display type" do
    I18n.backend.store_translations :en, {document: {type: {stub: {one: 'Stub'}}}}
    assert_equal "Stub", t_display_type(@document)
  end

  test "sorted_locales returns default locale first" do
    assert_equal I18n.default_locale, sorted_locales([:fr, :es, I18n.default_locale, :de]).first
  end

  test "sorted_locales returns other locals in alphabetically locale code order" do
    assert_equal [:de, :es, :fr], sorted_locales([:fr, :es, I18n.default_locale, :de])[1..-1]
  end

  test "t_delivery_title returns minister value if document was delivered by minister" do
    I18n.backend.store_translations :en, {document: {speech: {delivery_title: {minister: 'minister-value'}}}}
    assert_equal "minister-value", t_delivery_title(stub('document', delivered_by_minister?: true))
  end

  test "t_delivery_title returns speaker value if document was not delivered by minister" do
    I18n.backend.store_translations :en, {document: {speech: {delivery_title: {speaker: 'speaker-value'}}}}
    assert_equal "speaker-value", t_delivery_title(stub('document', delivered_by_minister?: false))
  end
end
