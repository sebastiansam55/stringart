import 'dart:html';
import 'dart:math';

int width = 900,
height = 900;

bool nailed = true;
bool axissymmetry = false;
bool leftrightsymmetry = false;
bool topbottomsymmetry = false;

CanvasRenderingContext2D render;

List<Nail> nails = new List<Nail>();
List<SString> sstrings = new List<SString>();
SString tmpstring = new SString();


void main() {
	Element canvasdiv = divElement("canvas");
	CanvasElement canvas = drawCanvas(canvasdiv);
	render = canvas.getContext("2d");
		
	
	
	document.body.nodes.add(canvasdiv);
	
	document.getElementById("axissymmetry").onChange.listen((Event e){
		axissymmetry = document.getElementById("axissymmetry").checked;
	});
	
	document.getElementById("leftrightsymmetry").onChange.listen((Event e){
		leftrightsymmetry = document.getElementById("leftrightsymmetry").checked;
	});
	
	document.getElementById("topbottomsymmetry").onChange.listen((Event e){
		topbottomsymmetry = document.getElementById("topbottomsymmetry").checked;
	});

	canvas.onMouseMove.listen((MouseEvent e){
		var x = (e.offset.x);
		var y = (e.offset.y);
		if(!tmpstring.started){
			clearBoard(render);
			renderCanvas();
			tmpstring.endPoint(x, y);
			tmpstring.draw(render);
		}
	});
	
	canvas.onClick.listen((MouseEvent e){
		var x = (e.offset.x);
		var y = (e.offset.y);
		
		if(e.altKey){
			//remove nail
			
		
		}else if(e.ctrlKey){
			//string 
			print("Clicked at: "+x.toString()+","+y.toString());
			for(var i = 0; i<nails.length; i++){
				var cur = nails.elementAt(i);
				print(cur.getX().toString()+","+cur.getY().toString());
				if(x>=cur.getX()-5 && x<=cur.getX()+5){				
					if(y>=cur.getY()-5 && y<=cur.getY()+5){					
						if(tmpstring.started){
							tmpstring.startPoint(cur.getX(),cur.getY());
							int r = int.parse(document.getElementById("red").value);
							int g = int.parse(document.getElementById("green").value);
							int b = int.parse(document.getElementById("blue").value);
							tmpstring.setColor(r,g,b);
							tmpstring.started = false;
						}else{
							tmpstring.endPoint(cur.getX(), cur.getY());
							sstrings.add(tmpstring);
							tmpstring = new SString();				
						}
						renderCanvas();
						return;
					}
				}
			}
		}else{
			//nail placement
			print("Clicked at: "+x.toString()+","+y.toString());
			for(var i = 0; i<nails.length; i++){
				var cur = nails.elementAt(i);
				print(cur.getX().toString()+","+cur.getY().toString());
				if(x>=cur.getX()-5 && x<=cur.getX()+5){				
					if(y>=cur.getY()-5 && y<=cur.getY()+5){					
						nails.remove(nails.elementAt(i));
						print("Toggle");
						renderCanvas();
						return;
					}
				}
			}
			if(axissymmetry){
				nails.add(new Nail(width-x, height-y));
			}
			if(leftrightsymmetry){
				nails.add(new Nail(width-x, y));
			}
			if(topbottomsymmetry){
				nails.add(new Nail(x, height-y));
			}
			nails.add(new Nail(x,y));
		}
		
		renderCanvas();
	});
	
	clearBoard(render);
}

renderCanvas(){
	clearBoard(render);
	for(var i = 0; i<nails.length; i++){
		nails.elementAt(i).draw(render);
	}	
	for(var j = 0; j<sstrings.length; j++){
		sstrings.elementAt(j).draw(render);
	}
}

Element drawCanvas(Element addTo){
	var canvas = new Element.html('<canvas/>');
	canvas.width = width;
	canvas.height = height;
	addTo.children.add(canvas);
	return canvas;
}

DivElement divElement(String ID){
	var div = new Element.html('<div />');
	div.id = ID;
	document.body.nodes.add(div);
	return div;
}

clearBoard(CanvasRenderingContext2D context){
	context.clearRect(0,0,width,height); 
	context.fillStyle = '#ffffff'; 
	context.strokeStyle = '#000000'; 
	context.fillRect(0,0,width,height);
}

class Nail{
	int x;
	int y;
	static int radius = 2;
	
	Nail(int x, int y){
		this.x = x;
		this.y = y;
	}
	
	draw(CanvasRenderingContext2D context){
		context.beginPath();
		context.arc(x,y, radius, 0, 2*PI);
		context.fillStyle = 'black';
		context.fill();
		context.stroke();
		context.closePath();
	}
	
	int getX(){return x;}
	int getY(){return y;}
}

class SString{
	int x;
	int y;
	int endx;
	int endy;
	bool started = true;
	int r,g,b;
	
	SString(){

	}
	
	draw(CanvasRenderingContext2D context){
		context.beginPath();
		context.moveTo(x,y);
		context.lineTo(endx, endy);
		context.setStrokeColorRgb(r, g, b, 1);
		context.stroke();
		context.closePath();
	}
	
	setColor(int r, int g, int b){
		this.r = r;
		this.g = g;
		this.b = b;
	}
	
	startPoint(int x, int y){
		this.x = x;
		this.y = y;
	}
	
	endPoint(int x, int y){
		this.endx = x;
		this.endy = y;
	}
}

/*  TODO:
 * Add symmetric nail placement
 * 
 *
 */