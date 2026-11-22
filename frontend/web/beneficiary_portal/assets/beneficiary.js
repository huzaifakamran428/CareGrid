(() => {
  'use strict';
  const root=document.getElementById('beneficiary-card-root');
  const input=document.getElementById('lookup');
  const esc=x=>String(x??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
  let records=[];
  let sampleCards={};
  try {
    const saved=JSON.parse(sessionStorage.getItem('caregrid_ngowalkin_demo_v3')||'{}');
    records=Array.isArray(saved.records)?saved.records:[];
    sampleCards=saved.sampleCards||{};
  } catch(_) {}
  // The fictional example card shares only local demo state with the NGO sample table.
  const example={name:'Ayesha Malik',digitalId:'CG-BEN-1001',cnic:'35201-0000000-0',address:'Model Town, Lahore (fictional example)',issuedAt:'14 Nov 2026',cardStatus:'Active',status:'Approved',...(sampleCards['BEN-1001']||{})};
  const displayCnic=v=>/^\d{13}$/.test(String(v||''))?`${v.slice(0,5)}-${v.slice(5,12)}-${v.slice(12)}`:v;
  function card(b){
    const active=!['Suspended','Blocked','Deleted'].includes(b.cardStatus);
    const photo=b.photo?`<img src="${esc(b.photo)}" class="card-portrait" alt="Beneficiary portrait">`:'<div class="card-portrait empty-portrait">👤</div>';
    return `<h2 class="mobile-card-title">Your beneficiary card</h2><div class="identity-card ${active?'':'id-suspended'}"><div class="id-card-top"><div class="id-brand"><img src="assets/caregrid-logo.jpg" alt="CareGrid logo"><div><strong>CareGrid</strong><small>BENEFICIARY DIGITAL ID</small></div></div><span class="card-status">${active?'ACTIVE · DEMO':'BLOCKED · DEMO'}</span></div><div class="id-card-body">${photo}<div class="id-card-info"><span class="id-label">Name</span><strong>${esc(b.name)}</strong><span class="id-label">Digital ID</span><strong class="id-code">${esc(b.digitalId)}</strong><span class="id-label">CNIC</span><strong>${esc(displayCnic(b.cnic))}</strong><span class="id-label">Address</span><p>${esc(b.address)}</p></div></div><div class="id-card-footer"><span>Issued ${esc(b.issuedAt)}</span><strong>DEMO ONLY · NOT VERIFIABLE</strong></div></div><p class="card-preview-hint">Card status: <strong>${active?'Active':'Blocked'}</strong>. Contact your NGO to correct your details. This card cannot be used as official identification.</p>`;
  }
  function lookup(){
    const id=input.value.trim().toUpperCase();
    const found=records.find(b=>b.digitalId?.toUpperCase()===id)||(id===example.digitalId?example:null);
    root.innerHTML=found?card(found):'<div class="no-card">No matching demo card found in this browser session. Register through the NGO screen first or try CG-BEN-1001.</div>';
  }
  document.getElementById('lookupBtn').addEventListener('click',lookup);
  input.addEventListener('keydown',e=>{if(e.key==='Enter')lookup()});
  let selected='';try{selected=sessionStorage.getItem('caregrid_selected_beneficiary_v3')||''}catch(_){}
  input.value=selected||example.digitalId;lookup();
})();