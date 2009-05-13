﻿// pixusRuler class
// (cc)2007 01media reactor
// By Jam Zhang
// jam@01media.cn

package {
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Screen;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;

	public class pixusRuler extends Sprite {
		const INTERVAL:uint=100;
		const TEXTURE_WIDTH:uint=100;
		const TEXTURE_SEGMENT:uint=1024;
		const TEXTURE_HEIGHT:uint=10;
		private var currentMarkPosition:uint=INTERVAL;
		private var currentBitmapLength:uint=0;
		private var rulerMask:Sprite=new Sprite();
		private var rulerContent:Sprite=new Sprite();
		private var bg:Sprite=new Sprite();
		private var fg:Sprite=new Sprite();
		private var direction:int;

		public function pixusRuler() {
			if(name.indexOf('Vertical')==-1)
				direction=1;
			else
				direction=-1;
			rulerMask.graphics.beginFill(0x0000);
			rulerMask.graphics.drawRect(0,0,TEXTURE_SEGMENT*direction,TEXTURE_HEIGHT);
			rulerMask.graphics.endFill();
			rulerContent.addChild(bg);
			rulerContent.addChild(fg);
			addChild(rulerMask);
			addChild(rulerContent);
			rulerContent.mask=rulerMask;
			extendRuler();
		}

		public function extendRuler(){
			// Shift bitmap left by 1 pixel when a negative rectangle is filled
			// Without this step, the origin line will be missing in case it's a vertical ruler
			var matrix:Matrix=new Matrix();
			if(direction==-1)
				matrix.tx=-1;
			currentBitmapLength+=TEXTURE_SEGMENT;
			bg.graphics.beginBitmapFill(new bitmapRulerTexture(TEXTURE_WIDTH,TEXTURE_HEIGHT),matrix);
			bg.graphics.drawRect(0,0,currentBitmapLength*direction,10);
			bg.graphics.endFill();
			for(;currentMarkPosition<currentBitmapLength;currentMarkPosition+=INTERVAL){
				var mark;
				if(direction==1)
					mark=new rulerMarkHorizontal(String(currentMarkPosition));
				else
					mark=new rulerMarkVertical(String(currentMarkPosition));
				mark.x=currentMarkPosition*direction;
				fg.addChild(mark);
			}
		}

		public function setLength(l:int):void {
			if(l>currentBitmapLength)
				extendRuler();
			rulerMask.width=l+1;
		}
	}
}