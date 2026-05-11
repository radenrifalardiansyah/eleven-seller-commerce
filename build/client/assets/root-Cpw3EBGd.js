import{r as o,j as e}from"./index-BX21vB6L.js";import{l as p,n as S,o as y,p as w,_ as f,q as a,M as g,L as M,O as k,S as c}from"./components-oMMKdM71.js";/**
 * @remix-run/react v2.17.4
 *
 * Copyright (c) Remix Software Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE.md file in the root directory of this source tree.
 *
 * @license MIT
 */let l="positions";function b({getKey:r,...d}){let{isSpaMode:h}=p(),n=S(),u=y();w({getKey:r,storageKey:l});let m=o.useMemo(()=>{if(!r)return null;let t=r(n,u);return t!==n.key?t:null},[]);if(h)return null;let x=((t,j)=>{if(!window.history.state||!window.history.state.key){let s=Math.random().toString(32).slice(2);window.history.replaceState({key:s},"")}try{let i=JSON.parse(sessionStorage.getItem(t)||"{}")[j||window.history.state.key];typeof i=="number"&&window.scrollTo(0,i)}catch(s){console.error(s),sessionStorage.removeItem(t)}}).toString();return o.createElement("script",f({},d,{suppressHydrationWarning:!0,dangerouslySetInnerHTML:{__html:`(${x})(${a(JSON.stringify(l))}, ${a(JSON.stringify(m))})`}}))}function O(){return e.jsxs("html",{lang:"en",children:[e.jsxs("head",{children:[e.jsx("meta",{charSet:"utf-8"}),e.jsx("meta",{name:"viewport",content:"width=device-width, initial-scale=1"}),e.jsx("title",{children:"Seller Management Dashboard"})]}),e.jsxs("body",{children:[e.jsx("div",{id:"root",children:"Loading..."}),e.jsx(c,{})]})]})}function R(){return e.jsxs("html",{lang:"en",children:[e.jsxs("head",{children:[e.jsx("meta",{charSet:"utf-8"}),e.jsx("meta",{name:"viewport",content:"width=device-width, initial-scale=1"}),e.jsx("title",{children:"Seller Management Dashboard"}),e.jsx(g,{}),e.jsx(M,{})]}),e.jsxs("body",{children:[e.jsx(k,{}),e.jsx(b,{}),e.jsx(c,{})]})]})}export{O as HydrateFallback,R as default};
