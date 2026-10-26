<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Superfície de Boy e esfera móvel — Geometric Lab</title>
<style>
:root{color-scheme:dark;--panel:#101d30;--line:#263a55;--text:#eaf2ff;--muted:#a8bad2}
*{box-sizing:border-box}
body{margin:0;background:radial-gradient(ellipse at top,#12243a,#08111f 60%);color:var(--text);font:15px/1.45 system-ui,-apple-system,Segoe UI,sans-serif}
header{padding:18px 22px 10px;max-width:1400px;margin:auto}
h1{font-size:clamp(1.25rem,3vw,1.8rem);margin:0 0 5px}
p{margin:4px 0;color:var(--muted)}
main{max-width:1400px;margin:auto;padding:10px 18px 24px;display:grid;grid-template-columns:minmax(0,1fr) 300px;gap:14px}
#view{height:min(74vh,760px);min-height:420px;border:1px solid var(--line);border-radius:16px;overflow:hidden;background:#07101c}
#view canvas{display:block;width:100%;height:100%}
.panel{background:rgba(16,29,48,.92);border:1px solid var(--line);border-radius:16px;padding:15px;height:max-content}
.control{margin:0 0 18px}.control label{display:flex;justify-content:space-between;gap:10px;font-weight:600;margin-bottom:7px}
input[type=range]{width:100%;accent-color:#77b9ff}
button{font:inherit;color:var(--text);background:#1b304b;border:1px solid #365171;border-radius:9px;padding:9px 10px;cursor:pointer}
button:hover{background:#294665}
.buttons{display:grid;grid-template-columns:1fr 1fr;gap:8px;margin-top:12px}
.toggle{display:flex;gap:8px;align-items:center;margin:9px 0;color:var(--muted)}
.toggle input{accent-color:#77b9ff}
.note{font-size:.88rem;color:var(--muted);margin-top:14px}
#status{font-size:.84rem;color:#a9d5ff;margin-top:10px}
@media(max-width:850px){main{grid-template-columns:1fr}#view{height:58vh;min-height:360px}.panel{order:2}}
</style>
<script type="importmap">
{"imports":{"three":"https://cdn.jsdelivr.net/npm/three@0.160.0/build/three.module.js","three/addons/":"https://cdn.jsdelivr.net/npm/three@0.160.0/examples/jsm/"}}
</script>
</head>
<body>
<header>
<h1>Superfície de Boy com esfera móvel</h1>
<p>Explore a superfície e mova a esfera ao longo da curva de auto-interseção indicada.</p>
</header>
<main>
<div id="view" aria-label="Visualização tridimensional interativa"></div>
<aside class="panel">
<div class="control">
<label for="radius"><span>Raio da esfera</span><output id="radiusOut">0.05</output></label>
<input id="radius" type="range" min="0.01" max="0.3" step="0.01" value="0.05">
</div>
<div class="control">
<label for="vpos"><span>Posição na curva (v)</span><output id="vout">π/4</output></label>
<input id="vpos" type="range" min="0.7853981634" max="1.5707963268" step="0.01" value="0.7853981634">
</div>
<div class="control">
<label for="opacity"><span>Opacidade da superfície</span><output id="opout">0.80</output></label>
<input id="opacity" type="range" min="0.1" max="1" step="0.05" value="0.8">
</div>
<div class="toggle"><input id="showSurface" type="checkbox" checked><label for="showSurface">Mostrar superfície de Boy</label></div>
<div class="toggle"><input id="showSphere" type="checkbox" checked><label for="showSphere">Mostrar esfera</label></div>
<div class="toggle"><input id="showCurve" type="checkbox" checked><label for="showCurve">Mostrar curva de referência</label></div>
<div class="buttons">
<button id="reset">Resetar câmera</button>
<button id="autorotate" aria-pressed="false">Iniciar rotação</button>
<button id="newtab">Abrir em nova aba</button>
<button id="fullscreen">Tela cheia</button>
</div>
<div id="status">Arraste para girar; use a roda do mouse para zoom.</div>
<div class="note">
<strong>Parametrização</strong><br>
x = ½ cos(u) sin(2v)<br>
y = ½ sin(u) sin(2v)<br>
z = ½(cos²(v) − cos²(u)sin²(v))<br>
0 ≤ u ≤ 2π, 0 ≤ v ≤ π/2.<br><br>
Centro da esfera: (0, 0, ½ cos(2v)).
</div>
</aside>
</main>
<script type="module">
import * as THREE from 'three';
import {OrbitControls} from 'three/addons/controls/OrbitControls.js';

const root=document.getElementById('view');
const scene=new THREE.Scene();scene.background=new THREE.Color(0x07101c);
const camera=new THREE.PerspectiveCamera(43,1,.01,1000);
const renderer=new THREE.WebGLRenderer({antialias:true});
renderer.setPixelRatio(Math.min(window.devicePixelRatio||1,2));
renderer.outputColorSpace=THREE.SRGBColorSpace;root.appendChild(renderer.domElement);
const controls=new OrbitControls(camera,renderer.domElement);
controls.enableDamping=true;controls.dampingFactor=.07;controls.autoRotate=false;controls.autoRotateSpeed=1.25;
const initialPos=new THREE.Vector3(3.6,4.2,3.7);
function resetCamera(){camera.position.copy(initialPos);controls.target.set(0,0,0);controls.update();}
resetCamera();
scene.add(new THREE.HemisphereLight(0xdcecff,0x253044,2));
const light=new THREE.DirectionalLight(0xffffff,2.1);light.position.set(4,7,6);scene.add(light);

function boy(u,v){
 return new THREE.Vector3(
  .5*Math.cos(u)*Math.sin(2*v),
  .5*Math.sin(u)*Math.sin(2*v),
  .5*(Math.cos(v)**2-(Math.cos(u)**2)*(Math.sin(v)**2))
 );
}
function makeBoyGeometry(nu,nv){
 const positions=[],indices=[];
 for(let i=0;i<=nu;i++){
  const u=2*Math.PI*i/nu;
  for(let j=0;j<=nv;j++){
   const v=(Math.PI/2)*j/nv,p=boy(u,v);
   positions.push(p.x,p.y,p.z);
  }
 }
 for(let i=0;i<nu;i++)for(let j=0;j<nv;j++){
  const a=i*(nv+1)+j,b=(i+1)*(nv+1)+j,c=b+1,d=a+1;
  indices.push(a,b,d,b,c,d);
 }
 const geo=new THREE.BufferGeometry();
 geo.setAttribute('position',new THREE.Float32BufferAttribute(positions,3));
 geo.setIndex(indices);geo.computeVertexNormals();return geo;
}
const surfaceMat=new THREE.MeshStandardMaterial({color:0xff9b32,side:THREE.DoubleSide,transparent:true,opacity:.8,roughness:.6,metalness:.02});
const surface=new THREE.Mesh(makeBoyGeometry(220,100),surfaceMat);scene.add(surface);
const sphereMat=new THREE.MeshStandardMaterial({color:0xff333d,side:THREE.DoubleSide,transparent:true,opacity:.8,roughness:.32,depthWrite:false});
const sphere=new THREE.Mesh(new THREE.SphereGeometry(1,48,32),sphereMat);scene.add(sphere);
const curveMat=new THREE.LineBasicMaterial({color:0x61d6ff});
const curvePoints=[];
for(let i=0;i<=200;i++){
 const v=Math.PI/4+(Math.PI/4)*i/200;
 curvePoints.push(new THREE.Vector3(0,0,.5*Math.cos(2*v)));
}
const curve=new THREE.Line(new THREE.BufferGeometry().setFromPoints(curvePoints),curveMat);scene.add(curve);
const centerMarker=new THREE.Mesh(new THREE.SphereGeometry(.025,16,12),new THREE.MeshStandardMaterial({color:0xffffff,emissive:0x777777}));scene.add(centerMarker);
const axes=new THREE.AxesHelper(.8);scene.add(axes);

const $=id=>document.getElementById(id);
function update(){
 const r=+$('radius').value,v=+$('vpos').value,op=+$('opacity').value;
 $('radiusOut').textContent=r.toFixed(2);
 $('vout').textContent=v.toFixed(3)+' rad';
 $('opout').textContent=op.toFixed(2);
 sphere.scale.setScalar(r);sphere.position.set(0,0,.5*Math.cos(2*v));centerMarker.position.copy(sphere.position);
 surfaceMat.opacity=op;
 surface.visible=$('showSurface').checked;
 sphere.visible=$('showSphere').checked;
 curve.visible=$('showCurve').checked;
 centerMarker.visible=$('showCurve').checked&&$('showSphere').checked;
}
['radius','vpos','opacity'].forEach(id=>$(id).addEventListener('input',update));
['showSurface','showSphere','showCurve'].forEach(id=>$(id).addEventListener('change',update));
$('reset').addEventListener('click',resetCamera);
$('autorotate').addEventListener('click',()=>{
 controls.autoRotate=!controls.autoRotate;
 $('autorotate').textContent=controls.autoRotate?'Parar rotação':'Iniciar rotação';
 $('autorotate').setAttribute('aria-pressed',String(controls.autoRotate));
});
$('newtab').addEventListener('click',()=>window.open(window.location.href,'_blank','noopener'));
$('fullscreen').addEventListener('click',async()=>{
 try{if(!document.fullscreenElement)await document.documentElement.requestFullscreen();else await document.exitFullscreen();}
 catch(e){$('status').textContent='Tela cheia indisponível neste contexto; tente abrir em nova aba.';}
});
function resize(){const w=Math.max(1,root.clientWidth),h=Math.max(1,root.clientHeight);camera.aspect=w/h;camera.updateProjectionMatrix();renderer.setSize(w,h,false);}
new ResizeObserver(resize).observe(root);resize();update();
function animate(){requestAnimationFrame(animate);controls.update();renderer.render(scene,camera);}
animate();
</script>
</body>
</html>
