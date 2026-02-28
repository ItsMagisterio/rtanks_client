package controls.rangicons
{
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   public class RangIconNormal extends RangIcon
   {
      
[Embed(source="863.png")]
      private static const p1:Class;
      
[Embed(source="864.png")]
      private static const p2:Class;
      
[Embed(source="861.png")]
      private static const p3:Class;
      
[Embed(source="862.png")]
      private static const p4:Class;
      
[Embed(source="855.png")]
      private static const p5:Class;
      
[Embed(source="856.png")]
      private static const p6:Class;
      
[Embed(source="853.png")]
      private static const p7:Class;
      
[Embed(source="854.png")]
      private static const p8:Class;
      
[Embed(source="858.png")]
      private static const p9:Class;
    
[Embed(source="859.png")]	  
      private static const p10:Class;
 
[Embed(source="772.png")]	 	   
      private static const p11:Class;
	  
[Embed(source="768.png")]	 	  
      private static const p12:Class;
    
[Embed(source="769.png")]	 	  
      private static const p13:Class;

[Embed(source="765.png")]	       
      private static const p14:Class;
 
[Embed(source="767.png")]	 	  
      private static const p15:Class;

[Embed(source="762.png")]	      
      private static const p16:Class;
      
[Embed(source="764.png")]	 	  
      private static const p17:Class;

[Embed(source="760.png")]	       
      private static const p18:Class;

[Embed(source="761.png")]	       
      private static const p19:Class;

[Embed(source="795.png")]	       
      private static const p20:Class;

[Embed(source="797.png")]	       
      private static const p21:Class;

[Embed(source="798.png")]	       
      private static const p22:Class;
 
[Embed(source="799.png")]	 	  
      private static const p23:Class;

[Embed(source="800.png")]	       
      private static const p24:Class;

[Embed(source="789.png")]	       
      private static const p25:Class;

[Embed(source="790.png")]	       
      private static const p26:Class;
      
[Embed(source="963.png")]
      private static const p27:Class; 
      
      public var g:MovieClip;
      
      private var gl:DisplayObject;
      
      private var rangs1:Array;
      
      public function RangIconNormal(param1:int = 1)
      {
         this.rangs1 = [new p1(),new p2(),new p3(),new p4(),new p5(),new p6(),new p7(),new p8(),new p9(),new p10(),new p11(),new p12(),new p13(),new p14(),new p15(),new p16(),new p17(),new p18(),new p19(),new p20(),new p21(),new p22(),new p23(),new p24(),new p25(),new p26(),new p27()];
         addFrameScript(0,this.frame1);
         super(param1);
         this.removeChildren();
         this._rang = param1;
         this.addChild(new Bitmap(this.rangs1[param1 - 1].bitmapData));
      }
      
      public function set glow(param1:Boolean) : void
      {
         this.gl.visible = param1;
      }
      
      public function set rang1(param1:int) : void
      {
         this.removeChildren();
         this._rang = param1;
         this.addChild(new Bitmap(this.rangs1[param1 - 1].bitmapData));
      }
      
      private function frame1() : void
      {
         stop();
      }
   }
}
