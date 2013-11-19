package {
	
	import flash.display.MovieClip;
	import org.osflash.signals.Signal;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;

	
	
	public class ButtonClose extends MovieClip {
		
		public var closeBoardSignal:Signal = new Signal();
		
		
		public function ButtonClose() {
			// constructor code
			this.buttonMode = true;
			this.addEventListener( MouseEvent.CLICK, btCloseClicked );
			this.addEventListener( MouseEvent.MOUSE_OVER, btCloseOnOver );
			this.addEventListener( MouseEvent.MOUSE_OUT, btCloseOnOut );
		}
		
		
		private function btCloseClicked( e:MouseEvent ):void
        {
            closeBoardSignal.dispatch();
		}
		
		private function btCloseOnOver( e:MouseEvent ):void
        {
            this.filters = [new GlowFilter( 0x32ebfb, .75, 5, 5, 2, 3, false, false )];
        }


        private function btCloseOnOut( e:MouseEvent ):void
        {
            this.filters = [];
        }
	}
	
}
