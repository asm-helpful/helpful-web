describe("conversations", function(){
  describe("onArchiveClick", function() {
    it("should return false", function() {
      expect(conversations.onArchiveClick()).toBe(false);
    });

    it("should place a post request", function() {
      spyOn($, 'post');
      conversations.onArchiveClick();

      expect($.post).toHaveBeenCalled();
    });
  });
});
