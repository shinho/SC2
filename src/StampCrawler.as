package {
	import flash.display.Sprite;
	
	
	
	/**
	 * ...
	 * @author Nelson Alexandre
	 * 2011
	 */
	public class StampCrawler extends Sprite {
		protected var context:StampCrawlerContext;
		
		
		
		public function StampCrawler() {
			context = new StampCrawlerContext(this);
		}
	}
}