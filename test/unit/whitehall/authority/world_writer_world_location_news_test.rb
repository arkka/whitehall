require 'unit/whitehall/authority/authority_test_helper'
require 'ostruct'

class WorldWriterWorldLocationNewsTest < ActiveSupport::TestCase
  def world_writer(world_locations, id = 1)
    OpenStruct.new(id: id, gds_editor?: false,
                   departmental_editor?: false, world_editor?: false,
                   world_writer?: true, organisation: nil,
                   world_locations: world_locations || [])
  end

  include AuthorityTestHelper

  test 'can create a new world location news article' do
    assert enforcer_for(world_writer(['hat land']), WorldLocationNewsArticle).can?(:create)
  end

  test 'can see a world location news article that is not access limited if it is about their location' do
    user = world_writer(['hat land', 'tie land'])
    edition = with_locations(normal_world_location_news_article, ['shirt land', 'hat land'])
    assert enforcer_for(user, edition).can?(:see)
  end

  test 'can see a world location news article about their location that is access limited if it is limited to their organisation' do
    org = 'organisation'
    user = world_writer(['hat land', 'tie land'])
    user.stubs(:organisation).returns(org)
    edition = with_locations(limited_world_location_news_article([org]), ['shirt land', 'hat land'])
    assert enforcer_for(user, edition).can?(:see)
  end

  test 'cannot see a world location news article about their locaiton that is access limited if it is limited an organisation they don\'t belong to' do
    org1 = 'organisation_1'
    org2 = 'organisation_2'
    user = world_writer(['hat land', 'tie land'])
    user.stubs(:organisation).returns(org1)
    edition = with_locations(limited_world_location_news_article([org2]), ['shirt land', 'hat land'])

    refute enforcer_for(user, edition).can?(:see)
  end

  test 'cannot see a world location news article that is not about their location' do
    user = world_writer(['tie land'])
    edition = with_locations(normal_world_location_news_article, ['shirt land'])
    refute enforcer_for(user, edition).can?(:see)
  end

  test 'cannot do anything to a world location news article they are not allowed to see' do
    user = world_writer(['tie land'])
    edition = with_locations(normal_world_location_news_article, ['shirt land'])
    enforcer = enforcer_for(user, edition)

    Whitehall::Authority::Rules::EditionRules.actions.each do |action|
      refute enforcer.can?(action)
    end
  end

  test 'can create a new edition of a world location news article that is about their location and not access limited' do
    user = world_writer(['hat land', 'tie land'])
    edition = with_locations(normal_world_location_news_article, ['shirt land', 'hat land'])

    assert enforcer_for(user, edition).can?(:create)
  end

  test 'can make changes to a world location news article that is about their location and not access limited' do
    user = world_writer(['hat land', 'tie land'])
    edition = with_locations(normal_world_location_news_article, ['shirt land', 'hat land'])

    assert enforcer_for(user, edition).can?(:update)
  end

  test 'can delete a world location news article that is about their location and not access limited' do
    user = world_writer(['hat land', 'tie land'])
    edition = with_locations(normal_world_location_news_article, ['shirt land', 'hat land'])

    assert enforcer_for(user, edition).can?(:delete)
  end

  test 'can make a fact check request for a edition that is about their location and not access limited' do
    user = world_writer(['hat land', 'tie land'])
    edition = with_locations(normal_world_location_news_article, ['shirt land', 'hat land'])

    assert enforcer_for(user, edition).can?(:make_fact_check)
  end

  test 'can view fact check requests on a edition that is about their location and not access limited' do
    user = world_writer(['hat land', 'tie land'])
    edition = with_locations(normal_world_location_news_article, ['shirt land', 'hat land'])

    assert enforcer_for(user, edition).can?(:review_fact_check)
  end

  test 'cannot publish a world location news article that is about their location and not access limited' do
    user = world_writer(['hat land', 'tie land'])
    edition = with_locations(normal_world_location_news_article, ['shirt land', 'hat land'])

    refute enforcer_for(user, edition).can?(:publish)
  end

  test 'cannot reject a world location news article that is about their location and not access limited' do
    user = world_writer(['hat land', 'tie land'])
    edition = with_locations(normal_world_location_news_article, ['shirt land', 'hat land'])

    refute enforcer_for(user, edition).can?(:reject)
  end

  test 'cannot force publish a world location news article that is about their location and not access limited' do
    user = world_writer(['hat land', 'tie land'])
    edition = with_locations(normal_world_location_news_article, ['shirt land', 'hat land'])

    refute enforcer_for(user, edition).can?(:force_publish)
  end

  test 'can make editorial remarks that is about their location and not access limited' do
    user = world_writer(['hat land', 'tie land'])
    edition = with_locations(normal_world_location_news_article, ['shirt land', 'hat land'])

    assert enforcer_for(user, edition).can?(:make_editorial_remark)
  end

  test 'can review editorial remarks that is about their location and not access limited' do
    user = world_writer(['hat land', 'tie land'])
    edition = with_locations(normal_world_location_news_article, ['shirt land', 'hat land'])

    assert enforcer_for(user, edition).can?(:review_editorial_remark)
  end

  test 'cannot clear the "not reviewed" flag on editions about their location and not access limited' do
    user = world_writer(['hat land', 'tie land'])
    edition = with_locations(normal_world_location_news_article, ['shirt land', 'hat land'])

    refute enforcer_for(user, edition).can?(:approve)
  end

  test 'can limit access to a world location news article that is about their location and not access limited' do
    user = world_writer(['hat land', 'tie land'])
    edition = with_locations(normal_world_location_news_article, ['shirt land', 'hat land'])

    assert enforcer_for(user, edition).can?(:limit_access)
  end

  test 'cannot unpublish a world location news article that is about their location and not access limited' do
    user = world_writer(['hat land', 'tie land'])
    edition = with_locations(normal_world_location_news_article, ['shirt land', 'hat land'])

    refute enforcer_for(user, edition).can?(:unpublish)
  end
end
