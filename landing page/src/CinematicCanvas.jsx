import React, { Suspense, useEffect, useMemo, useRef, useState } from "react";
import { Canvas, useFrame } from "@react-three/fiber";
import * as THREE from "three";

function CinematicCanvas({ reduceMotion }) {
  const [webglReady, setWebglReady] = useState(false);

  useEffect(() => {
    if (reduceMotion || window.matchMedia("(max-width: 47.99rem)").matches) {
      setWebglReady(false);
      return;
    }

    const canvas = document.createElement("canvas");
    const ready =
      !!window.WebGLRenderingContext &&
      !!(canvas.getContext("webgl") || canvas.getContext("experimental-webgl"));
    setWebglReady(ready);
  }, [reduceMotion]);

  if (reduceMotion || !webglReady) return null;

  return (
    <div className="cinematic-canvas" aria-hidden="true">
      <Canvas
        camera={{ position: [0, 0, 8], fov: 48 }}
        dpr={[1, 1.25]}
        gl={{ alpha: true, antialias: true, powerPreference: "high-performance" }}
      >
        <Suspense fallback={null}>
          <ambientLight intensity={0.55} />
          <ParticleField />
        </Suspense>
      </Canvas>
    </div>
  );
}

function readRgbToken(name, fallback) {
  const raw = getComputedStyle(document.documentElement).getPropertyValue(name).trim();
  const values = raw.split(/\s+/).map(Number).filter(Number.isFinite);
  return values.length === 3 ? values : fallback;
}

function ParticleField() {
  const groupRef = useRef(null);
  const materialRef = useRef(null);
  const count = 110;

  const positions = useMemo(() => {
    const data = new Float32Array(count * 3);
    let seed = 11;
    const random = () => {
      seed = (seed * 16807) % 2147483647;
      return (seed - 1) / 2147483646;
    };

    for (let index = 0; index < count; index += 1) {
      data[index * 3] = (random() - 0.5) * 11;
      data[index * 3 + 1] = (random() - 0.46) * 6.6;
      data[index * 3 + 2] = (random() - 0.5) * 4.2;
    }

    return data;
  }, [count]);

  useEffect(() => {
    if (!materialRef.current) return;
    const [r, g, b] = readRgbToken("--webgl-agent-rgb", [1, 0.38, 0.18]);
    materialRef.current.color.setRGB(r, g, b);
  }, []);

  useFrame(({ clock }) => {
    if (!groupRef.current) return;
    const elapsed = clock.getElapsedTime();
    groupRef.current.rotation.y = Math.sin(elapsed * 0.05) * 0.08;
    groupRef.current.rotation.x = Math.cos(elapsed * 0.05) * 0.035;
    groupRef.current.position.y = Math.sin(elapsed * 0.12) * 0.08;
  });

  return (
    <group ref={groupRef}>
      <points>
        <bufferGeometry>
          <bufferAttribute attach="attributes-position" args={[positions, 3]} />
        </bufferGeometry>
        <pointsMaterial
          ref={materialRef}
          size={0.026}
          transparent
          opacity={0.42}
          depthWrite={false}
          blending={THREE.AdditiveBlending}
        />
      </points>
    </group>
  );
}

export default CinematicCanvas;
