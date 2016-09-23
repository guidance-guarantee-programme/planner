//= require jquery
//= require jasmine-jquery

jasmine.getFixtures().fixturesPath = '../../spec/javascripts/fixtures';

describe('Calendar', function() {
  'use strict';

  it('should be defined', function() {
    expect(PWPLAN.Calendar).toBeDefined();
  });
});
