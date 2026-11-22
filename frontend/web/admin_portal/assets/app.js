/* CareGrid frontend-only preview. No APIs, login, storage or server writes. */
(() => {
  'use strict';
  // Build only the ADMIN presentation entry for this standalone web preview.
  const page = 'admin';
  if (document.body.dataset.page !== page) return;

  const paths = {
    dashboard:'<rect x="3" y="3" width="8" height="8" rx="1"/><rect x="13" y="3" width="8" height="5" rx="1"/><rect x="13" y="10" width="8" height="11" rx="1"/><rect x="3" y="13" width="8" height="8" rx="1"/>',
    people:'<path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75"/>',
    building:'<rect x="4" y="2" width="16" height="20" rx="2"/><path d="M9 22v-4h6v4M8 6h.01M16 6h.01M8 11h.01M16 11h.01"/>',
    wallet:'<rect x="2" y="5" width="20" height="16" rx="2"/><path d="M2 9h20M16 14h2"/>',
    mailbox:'<rect x="3" y="5" width="18" height="14" rx="2"/><path d="m3 7 9 7 9-7"/>',
    check:'<path d="M20 6 9 17l-5-5"/>',
    clock:'<circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/>',
    shield:'<path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10Z"/><path d="m9 12 2 2 4-4"/>',
    chart:'<path d="M4 19h16M6 16V9M11 16V5M16 16v-6M21 16V3"/>',
    heart:'<path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 0 0 0-7.78Z"/>',
    arrow:'<path d="M5 12h14m-6-6 6 6-6 6"/>',
    chevron:'<path d="m9 18 6-6-6-6"/>',
    plus:'<path d="M12 5v14M5 12h14"/>',
    search:'<circle cx="11" cy="11" r="7"/><path d="m20 20-4-4"/>',
    filter:'<path d="M4 7h16M7 12h10M10 17h4"/>',
    bell:'<path d="M18 8a6 6 0 0 0-12 0c0 7-3 7-3 9h18c0-2-3-2-3-9M10 21h4"/>',
    menu:'<path d="M4 7h16M4 12h16M4 17h16"/>',
    download:'<path d="M12 3v12m-4-4 4 4 4-4M4 17v4h16v-4"/>',
    edit:'<path d="m15 5 4 4M4 20l4.5-1 11-11a2.83 2.83 0 0 0-4-4l-11 11Z"/>',
    eye:'<path d="M2 12s3.7-7 10-7 10 7 10 7-3.7 7-10 7-10-7-10-7Z"/><circle cx="12" cy="12" r="3"/>',
    file:'<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8Z"/><path d="M14 2v6h6M8 13h8M8 17h8"/>',
    food:'<path d="M4 3v7a3 3 0 0 0 6 0V3M7 3v18M17 3c-2 3-3 6-3 10h5V3h-2ZM19 13v8"/>',
    stethoscope:'<path d="M6 3v7a5 5 0 0 0 10 0V3M4 3h4M14 3h4M11 16v1a4 4 0 0 0 8 0v-2"/><circle cx="19" cy="13" r="2"/>',
    settings:'<circle cx="12" cy="12" r="3"/><path d="m19.4 15 .1.1 1.5 1.2-1.5 2.6-1.9-.7a9 9 0 0 1-2.5 1.5L14.7 22h-3l-.4-2.3a9 9 0 0 1-2.5-1.5l-1.9.7-1.5-2.6 1.6-1.3a9 9 0 0 1 0-3L5.4 10l1.5-2.6 1.9.7a9 9 0 0 1 2.5-1.5L11.7 4h3l.4 2.3a9 9 0 0 1 2.5 1.5l1.9-.7 1.5 2.6-1.6 1.3a9 9 0 0 1 0 3Z"/>',
    x:'<path d="M18 6 6 18M6 6l12 12"/>',
    message:'<path d="M21 11.5a8.4 8.4 0 0 1-.9 3.8 8.5 8.5 0 0 1-7.6 4.7 8.4 8.4 0 0 1-3.8-.9L3 21l1.9-5.7a8.4 8.4 0 0 1-.9-3.8 8.5 8.5 0 0 1 4.7-7.6A8.4 8.4 0 0 1 12.5 3h.5a8.5 8.5 0 0 1 8 8v.5Z"/>',
    calendar:'<rect x="3" y="5" width="18" height="16" rx="2"/><path d="M7 3v4M17 3v4M3 10h18"/>',
    alert:'<path d="m12 3 10 18H2L12 3Z"/><path d="M12 9v4m0 4h.01"/>',
    refresh:'<path d="M20 7v5h-5M4 17v-5h5"/><path d="M5 9a8 8 0 0 1 14-2l1 5M4 12l1 5a8 8 0 0 0 14-2"/>',
    upload:'<path d="M12 16V3m-5 5 5-5 5 5M4 17v4h16v-4"/>'
  };
  const I = (name, cls='') => `<svg class="ic ${cls}" aria-hidden="true" viewBox="0 0 24 24">${paths[name] || paths.dashboard}</svg>`;
  const esc = value => String(value ?? '').replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
  const initials = name => String(name).split(/\s+/).slice(0,2).map(a=>a[0]||'').join('').toUpperCase();
  const chip = s => `<span class="pill ${String(s).toLowerCase().replaceAll(' ','-')}">${esc(s)}</span>`;
  const avatar = name => `<span class="avatar">${esc(initials(name))}</span>`;
  const person = (name,meta='') => `<span class="table-person">${avatar(name)}<span><strong>${esc(name)}</strong>${meta?`<small>${esc(meta)}</small>`:''}</span></span>`;
  const button = (label,action,variant='btn-secondary',id='') => `<button type="button" class="btn ${variant}" data-action="${action}" ${id?`data-id="${esc(id)}"`:''}>${label}</button>`;
  const stat = (label,value,sub,icon,color) => `<article class="card stat"><div class="stat-spark"></div><div class="stat-top"><span class="stat-label">${label}</span><span class="stat-icon ${color}">${I(icon)}</span></div><div class="stat-value">${value}</div><div class="stat-sub">${sub}</div></article>`;
  const sectionHeader = (title,desc,link='',target='') => `<div class="section-heading"><div><h2>${title}</h2>${desc?`<p>${desc}</p>`:''}</div>${link?`<a href="#${target}">${link} →</a>`:''}</div>`;
  const footer = n => `<div class="table-footer"><span>Showing ${n} sample record${n===1?'':'s'}</span><span>Demo data · UI only</span></div>`;
  const noResults = `<div class="table-empty">No matching sample records found. Try a different search or filter.</div>`;

  const data = {
    beneficiaries:[
      {id:'BEN-1001',name:'Ayesha Malik',phone:'0300 000 1001',location:'Lahore',status:'Approved',digitalId:'CG-BEN-1001',joined:'14 Nov 2026'},
      {id:'BEN-1002',name:'Bilal Ahmed',phone:'0300 000 1002',location:'Lahore',status:'Pending',digitalId:'—',joined:'13 Nov 2026'},
      {id:'BEN-1003',name:'Sana Fatima',phone:'0300 000 1003',location:'Kasur',status:'Approved',digitalId:'CG-BEN-1003',joined:'12 Nov 2026'},
      {id:'BEN-1004',name:'Hamza Ali',phone:'0300 000 1004',location:'Lahore',status:'Approved',digitalId:'CG-BEN-1004',joined:'11 Nov 2026'},
      {id:'BEN-1005',name:'Maryam Noor',phone:'0300 000 1005',location:'Sheikhupura',status:'Pending',digitalId:'—',joined:'10 Nov 2026'},
      {id:'BEN-1006',name:'Hassan Raza',phone:'0300 000 1006',location:'Lahore',status:'Approved',digitalId:'—',source:'NGO-verified sample',joined:'22 Nov 2026'}
    ],
    partners:[
      {id:'ORG-201',name:'FreshBite Kitchen',type:'Restaurant',location:'Lahore',status:'Approved',contact:'0300 000 2201'},
      {id:'ORG-202',name:'HealthFirst Pharmacy',type:'Pharmacy',location:'Lahore',status:'Pending',contact:'0300 000 2202'},
      {id:'ORG-203',name:'Nova Diagnostic Lab',type:'Laboratory',location:'Kasur',status:'Approved',contact:'0300 000 2203'},
      {id:'ORG-204',name:'Green Table Foods',type:'Restaurant',location:'Lahore',status:'Pending',contact:'0300 000 2204'}
    ],
    sponsors:[
      {id:'SP-301',name:'Usman Tariq',email:'usman@example.test',category:'Medical support',contribution:65000,status:'Active'},
      {id:'SP-302',name:'Noor Foundation',email:'contact@noor.example',category:'Food distribution',contribution:120000,status:'Active'},
      {id:'SP-303',name:'Hira Rehman',email:'hira@example.test',category:'General welfare',contribution:25000,status:'Pending'}
    ],
    registrations:[
      {id:'REG-501',name:'Sunrise Medical Lab',type:'Laboratory',submitted:'21 Nov 2026',location:'Lahore',status:'Pending',description:'Laboratory partnership request',documents:['Business registration.pdf','Service license.pdf']},
      {id:'REG-502',name:'Green Table Foods',type:'Restaurant',submitted:'20 Nov 2026',location:'Lahore',status:'Pending',description:'Surplus food donation partnership',documents:['Registration certificate.pdf']},
      {id:'REG-503',name:'HealthFirst Pharmacy',type:'Pharmacy',submitted:'20 Nov 2026',location:'Lahore',status:'Pending',description:'Subsidized medicine partner',documents:['Pharmacy license.pdf']},
      {id:'REG-504',name:'Helping Hands NGO',type:'NGO',submitted:'19 Nov 2026',location:'Kasur',status:'Pending',description:'NGO registration to use CareGrid',documents:['NGO registration.pdf']},
      {id:'REG-505',name:'FutureAid Sponsors',type:'Sponsor',submitted:'18 Nov 2026',location:'Lahore',status:'Approved',description:'Sponsor account application',documents:['Organization ID.pdf']}
    ],
    complaints:[
      {id:'CG-CMP-10241',name:'Ayesha Malik',subject:'Medicine subsidy not reflected',category:'Healthcare',date:'21 Nov 2026',priority:'High',status:'New',text:'I visited the partner pharmacy with my approved digital ID, but the expected medicine subsidy was not shown on the invoice. Please review the issue.',messages:[]},
      {id:'CG-CMP-10240',name:'Bilal Ahmed',subject:'Beneficiary application delay',category:'Registration',date:'20 Nov 2026',priority:'Standard',status:'In progress',text:'My beneficiary application still shows pending verification. I would like to know whether any additional information is required.',messages:[{author:'CareGrid Support',date:'21 Nov 2026',text:'We are reviewing the submitted registration details. Please monitor your application status for updates.'}]},
      {id:'CG-CMP-10239',name:'Sana Fatima',subject:'Incorrect lab appointment details',category:'Laboratory',date:'19 Nov 2026',priority:'Standard',status:'New',text:'The appointment confirmation in my account displays a different testing date from the one I selected.',messages:[]},
      {id:'CG-CMP-10238',name:'Hamza Ali',subject:'Food assistance request clarification',category:'Food support',date:'18 Nov 2026',priority:'Standard',status:'Resolved',text:'I needed clarification about my food support request and how to check the delivery status.',messages:[{author:'CareGrid Support',date:'19 Nov 2026',text:'Your request was reviewed. You can view its updated status from the welfare support area of the application.'}]},
      {id:'CG-CMP-10237',name:'Maryam Noor',subject:'Unable to view my digital ID',category:'Account access',date:'17 Nov 2026',priority:'High',status:'In progress',text:'I cannot see my digital ID even though I received a notification about my account status.',messages:[]}
    ],
    food:[{name:'FreshBite Kitchen',item:'Prepared meals',quantity:'75 portions',status:'Collected',date:'21 Nov 2026'},{name:'Green Table Foods',item:'Bread and vegetables',quantity:'42 portions',status:'Pending',date:'20 Nov 2026'},{name:'Sunset Café',item:'Packed rice',quantity:'30 portions',status:'Delivered',date:'19 Nov 2026'}],
    healthcare:[{name:'HealthFirst Pharmacy',service:'Medicine subsidy',beneficiary:'Ayesha Malik',amount:'Rs. 1,800',status:'Under review'},{name:'Nova Diagnostic Lab',service:'CBC lab test',beneficiary:'Hamza Ali',amount:'Rs. 950',status:'Processed'},{name:'WellCare Pharmacy',service:'Medicine subsidy',beneficiary:'Sana Fatima',amount:'Rs. 1,200',status:'Processed'}]
  };

  const state = {organizationType:'All',search:'',status:'All',partnerType:'All',complaintFilter:'All',selectedComplaint:'CG-CMP-10241',reportCategory:'Welfare summary',reportFrom:'2026-11-01',reportTo:'2026-11-22'};
  // UI-only draft recovery. Never store the document files; use fictional details in demos.
  const walkInDraftKey = 'caregrid_walkin_form_draft_v4';
  const draftFields = ['name','cnic','phone','location','address'];
  const draftCheckFields = ['originalChecked','billsChecked','consentChecked'];
  function saveWalkInDraft(form) {
    if (!form || page !== 'ngo') return;
    const values = {};
    for (const field of draftFields) values[field] = form.elements.namedItem(field)?.value || '';
    for (const field of draftCheckFields) values[field] = Boolean(form.elements.namedItem(field)?.checked);
    try { sessionStorage.setItem(walkInDraftKey, JSON.stringify(values)); } catch (_) { /* private browsing storage may be disabled */ }
  }
  function restoreWalkInDraft() {
    const form = document.getElementById('walkin-form');
    if (!form) return;
    try {
      const draft = JSON.parse(sessionStorage.getItem(walkInDraftKey) || 'null');
      if (!draft || typeof draft !== 'object') return;
      for (const field of draftFields) if (typeof draft[field] === 'string' && form.elements.namedItem(field)) form.elements.namedItem(field).value = draft[field];
      for (const field of draftCheckFields) if (form.elements.namedItem(field)) form.elements.namedItem(field).checked = Boolean(draft[field]);
      if (draftFields.some(field => draft[field]) || draftCheckFields.some(field => draft[field])) {
        const note = document.getElementById('draft-status');
        if (note) note.textContent = 'Your text fields were restored from this browser tab. For security, please select the document files again.';
      }
    } catch (_) { /* ignore corrupted demo draft */ }
  }
  function clearWalkInDraft() {
    try { sessionStorage.removeItem(walkInDraftKey); } catch (_) { /* no browser storage */ }
  }
  function validateBillFiles(files) {
    if (!files.length) return 'Select a combined file or several files covering all three months.';
    if (files.length > 6) return 'Choose no more than six files for the three-month bills.';
    const formats = ['pdf', 'jpg', 'jpeg', 'png', 'webp', 'heic', 'heif'];
    for (const file of files) {
      const ext = String(file.name || '').toLowerCase().split('.').pop();
      if (!formats.includes(ext)) return `Unsupported bill file: ${file.name}. Choose PDF or an image.`;
      if (!file.size || file.size > 5 * 1024 * 1024) return `Bill file ${file.name} must be non-empty and at most 5 MB.`;
    }
    return '';
  }
  function updateBillsFeedback(input) {
    const feedback = document.getElementById('bills-selection-feedback');
    if (!feedback) return;
    const files = Array.from(input.files || []);
    feedback.classList.remove('upload-error', 'upload-success');
    if (!files.length) {
      feedback.textContent = 'Select one combined PDF or multiple PDF/image files. NGO staff must confirm that all three months are covered.';
      return;
    }
    const error = validateBillFiles(files);
    if (error) { feedback.textContent = error; feedback.classList.add('upload-error'); return; }
    feedback.classList.add('upload-success');
    feedback.textContent = `${files.length} file${files.length === 1 ? '' : 's'} selected: ${files.map(f => f.name).join(', ')}. Confirm all three months in the checklist below.`;
  }
  let modalType = null;
  const allowedSections = {ngo:['overview','walk-in','beneficiaries','digital-ids','partners','sponsors'],admin:['overview','approvals','beneficiaries','organizations','monitoring','reports','complaints'],complaints:['inbox']};
  const active = () => allowedSections[page].includes(location.hash.slice(1))?location.hash.slice(1):allowedSections[page][0];
  const nav = page==='ngo' ? [{key:'overview',label:'Overview',icon:'dashboard'},{key:'walk-in',label:'Walk-in registration',icon:'plus'},{key:'beneficiaries',label:'Beneficiaries',icon:'people'},{key:'digital-ids',label:'Digital ID cards',icon:'shield'},{key:'partners',label:'Service providers',icon:'building'},{key:'sponsors',label:'Sponsors',icon:'wallet'}] : page==='admin' ? [{key:'overview',label:'Overview',icon:'dashboard'},{key:'approvals',label:'Registration requests',icon:'shield'},{key:'beneficiaries',label:'Beneficiary records',icon:'people'},{key:'organizations',label:'Organization records',icon:'building'},{key:'monitoring',label:'Service monitoring',icon:'chart'},{key:'reports',label:'Reports',icon:'file'},{key:'complaints',label:'Complaints',icon:'mailbox'}] : [{key:'inbox',label:'Complaint inbox',icon:'mailbox'}];
  const titleFor = () => ({overview:'Overview','walk-in':'Walk-in registration','digital-ids':'Digital ID cards',beneficiaries:'Beneficiaries',organizations:'Organization records',partners:'Service providers',sponsors:'Sponsors',approvals:'Registration requests',monitoring:'Service monitoring',reports:'Reports',complaints:'Complaints',inbox:'Complaint inbox'}[active()]);
  const roleName = page==='ngo'?'NGO Workspace':page==='admin'?'System Administration':'Admin · Complaints';

  function shell(body) {
    const pending = registrationRequests().filter(r=>r.status==='Pending').length;
    const navItems = nav.map(item=>`<a href="#${item.key}" class="${active()===item.key?'active':''}">${I(item.icon)}${esc(item.label)}${item.key==='approvals'?`<span class="nav-bubble">${pending}</span>`:item.key==='complaints'?`<span class="nav-bubble">${data.complaints.filter(c=>c.status!=='Resolved').length}</span>`:''}</a>`).join('');
    return `<div class="shell"><aside class="sidebar" aria-label="Main navigation"><div class="logo"><img src="assets/caregrid-logo.jpg" alt="CareGrid logo" class="logo-image"><span class="logo-title">Care<span class="brand-accent">Grid</span></span></div><div class="workspace-tag">${I(page==='ngo'?'heart':page==='admin'?'shield':'mailbox')}<div><strong>${roleName}</strong><span>Standalone frontend screen</span></div></div><div class="nav-head">WORKSPACE</div><nav class="side-nav">${navItems}</nav><div class="sidebar-bottom"><div class="sidebar-card" aria-label="Current portal"><strong>${I(page==='ngo'?'heart':'shield','sm')} ${page==='ngo'?'NGO workspace':'Admin workspace'}</strong><p>Role-specific UI preview. Navigation stays within this portal.</p></div></div></aside><div class="main"><header class="topbar"><div style="display:flex;align-items:center;gap:14px"><button type="button" class="circle-btn menu-btn" aria-label="Toggle menu" data-action="menu">${I('menu')}</button><div class="breadcrumb">CareGrid ${I('chevron','sm')} <strong>${esc(titleFor())}</strong></div></div><div class="top-actions"><span class="today">Prototype · Nov 2026</span><button class="circle-btn" title="Demo: no live notifications" data-action="notification">${I('bell')}<span class="dot"></span></button><div class="account"><span class="avatar">${page==='ngo'?'NG':page==='admin'?'AD':'CS'}</span><div class="account-label"><strong>${page==='ngo'?'NGO Coordinator':page==='admin'?'System Admin':'Complaint Officer'}</strong><small>Preview account</small></div></div></div></header><main class="content">${body}<div class="preview-banner">${I('alert','sm')} UI preview uses fictional sample records. Actions update the screen only and are not saved to CareGrid servers.</div></main></div></div><div id="modal-root"></div>`;
  }
  const heading = (tagline,title,desc,actions='') => `<div class="page-heading"><div><div class="eyebrow" style="margin-bottom:8px">${tagline}</div><h1>${title}</h1><p>${desc}</p></div><div class="heading-actions">${actions}</div></div>`;
  const searchBox = placeholder => `<label class="search">${I('search','sm')}<input data-search aria-label="Search records" autocomplete="off" placeholder="${esc(placeholder)}" value="${esc(state.search)}"></label>`;
  const selectStatus = statuses => `<select class="select" aria-label="Filter by status" data-status>${statuses.map(s=>`<option ${state.status===s?'selected':''}>${s}</option>`).join('')}</select>`;
  const rowTable = (heads,rows) => `<div class="table-scroll"><table class="data-table"><thead><tr>${heads.map(h=>`<th>${h}</th>`).join('')}</tr></thead><tbody>${rows.join('') || `<tr><td colspan="${heads.length}">${noResults}</td></tr>`}</tbody></table></div>${footer(rows.length)}`;
  const filterSearch = r => Object.values(r).join(' ').toLowerCase().includes(state.search.toLowerCase());

  function ngoOverview(){
    const approvalRate=Math.round(100*data.beneficiaries.filter(b=>b.status==='Approved').length/Math.max(data.beneficiaries.length,1));
    return `${heading('NGO WORKSPACE','Good morning, team 👋','Here’s a quick look at your welfare operations today.',`<a class="btn btn-primary" href="#walk-in">${I('plus')} Register walk-in</a>`)}
    <div class="banner"><div><div class="eyebrow">YOUR COMMUNITY IMPACT</div><h2>Small actions. Stronger communities.</h2><p>Keep your beneficiary records, partnerships and sponsor activities organized in one shared workspace.</p></div><div class="banner-art">${I('heart','lg')}</div></div>
    <div class="grid grid-four gap-top">${stat('Total beneficiaries',data.beneficiaries.length,`<span class="up">${data.beneficiaries.filter(b=>b.status==='Approved').length} approved</span> · ${data.beneficiaries.filter(b=>b.status==='Pending').length} pending`,'people','green')}${stat('Service providers',data.partners.length,'2 pending approval','building','blue')}${stat('Active sponsors',data.sponsors.filter(a=>a.status==='Active').length,'Across 3 support categories','wallet','purple')}${stat('Food donations','147 portions','Mock collection summary','food','amber')}</div>
    <div class="grid section-grid gap-top"><section class="card">${sectionHeader('Recent beneficiaries','Latest registered community members','View all','beneficiaries')}${rowTable(['Beneficiary','Digital ID','Status'],data.beneficiaries.slice(0,4).map(b=>`<tr><td>${person(b.name,b.location)}</td><td class="id-code">${esc(b.digitalId)}</td><td>${chip(b.status)}</td></tr>`))}</section><section class="card">${sectionHeader('Quick actions','Complete common tasks faster')}<div style="padding:0 21px 24px" class="quick-tiles"><button class="quick-tile" data-action="go-walk-in">${I('people')}Register beneficiary</button><button class="quick-tile" data-action="add-partner">${I('building')}Register partner</button><button class="quick-tile" data-action="add-sponsor">${I('wallet')}Add sponsor</button></div><div class="divider"></div>${sectionHeader('Registration progress','Example onboarding completion')}<div style="padding:0 23px 24px"><div class="progress-label"><span>Verified beneficiaries</span><strong>${approvalRate}%</strong></div><div class="progress-line"><b style="width:${approvalRate}%"></b></div><div class="field-hint">NGO walk-in registrations can be issued immediately after staff document checks. Other registration channels may require admin approval.</div></div></section></div>
    <div class="grid section-grid gap-top"><section class="card">${sectionHeader('Recent service providers','Partners joining the CareGrid network','View providers','partners')}${rowTable(['Organization','Category','Status'],data.partners.slice(0,3).map(p=>`<tr><td><strong>${esc(p.name)}</strong><small>${esc(p.location)}</small></td><td>${esc(p.type)}</td><td>${chip(p.status)}</td></tr>`))}</section><section class="card">${sectionHeader('Support allocation','Illustrative impact distribution')}<div class="donut-wrap"><div class="donut"><div class="donut-inner"><strong>68%</strong><small>Food support</small></div></div><div class="legend"><div class="legend-row"><span class="legend-dot"></span>Food support<b>68%</b></div><div class="legend-row"><span class="legend-dot amber"></span>Healthcare<b>17%</b></div><div class="legend-row"><span class="legend-dot grey"></span>Other welfare<b>15%</b></div></div></div></section></div>`;
  }
  // NGO-assisted registration is a separate workflow; no admin queue is created for walk-ins.
  const sampleId = () => {
    let candidate;
    do { candidate = 'CG-BEN-' + new Date().getFullYear() + '-' + String(++idSequence).padStart(5,'0'); }
    while (data.beneficiaries.some(b => b.digitalId === candidate));
    return candidate;
  };
  let idSequence = 5;
  // Only registered, active/approved beneficiaries without a card qualify for new issuance.
  const canIssueCard = b => Boolean(b && b.status === 'Approved' && b.registrationActive !== false && (!b.digitalId || b.digitalId === '—'));
  const eligibleBeneficiaries = () => data.beneficiaries.filter(canIssueCard);
  const displayCnic = value => /^\d{13}$/.test(String(value||'')) ? `${value.slice(0,5)}-${value.slice(5,12)}-${value.slice(12)}` : String(value||'');

  // Local-only demonstration archive, NOT an authenticated document-management service.
  // Metadata is shared between the NGO and Admin pages at the SAME local web origin.
  // Never test with real CNICs / salary slips / personal records.
  const archiveKey = 'caregrid_demo_shared_records_v7';
  const docsDatabase = 'caregrid_demo_files_v7';
  function openDocsDB() {
    return new Promise((resolve,reject)=>{
      if(!('indexedDB' in window)) { reject(new Error('IndexedDB unavailable')); return; }
      const request=indexedDB.open(docsDatabase,1);
      request.onupgradeneeded=()=>{const db=request.result;if(!db.objectStoreNames.contains('files'))db.createObjectStore('files',{keyPath:'key'});};
      request.onsuccess=()=>resolve(request.result);
      request.onerror=()=>reject(request.error||new Error('Storage failed'));
    });
  }
  async function storeDemoFile(ownerId,label,file,ordinal=0) {
    // IndexedDB stores the blob locally for THIS preview origin, not on any server.
    // No embedded data URLs, file bytes, or blobs are saved to localStorage.
    const key=`${ownerId}:${label}:${ordinal}`;
    const descriptor={key,label,name:file.name,mime:file.type||'',size:file.size,local:true};
    try{
      const db=await openDocsDB();
      await new Promise((resolve,reject)=>{
        const tx=db.transaction('files','readwrite');tx.objectStore('files').put({key,file});
        tx.oncomplete=()=>resolve();tx.onerror=()=>reject(tx.error||new Error('Upload cache unavailable'));
      });db.close();
    }catch(error){descriptor.local=false;}
    return descriptor;
  }
  async function getDemoFile(key) {
    const db=await openDocsDB();
    try{
      return await new Promise((resolve,reject)=>{
        const request=db.transaction('files','readonly').objectStore('files').get(key);
        request.onsuccess=()=>resolve(request.result?.file||null);
        request.onerror=()=>reject(request.error||new Error('Unable to load file'));
      });
    }finally{db.close();}
  }
  // Isolated portals do not publish NGO identity records into shared browser storage.
  // Actual Admin visibility requires authenticated backend/API integration.
  function publishAdminArchive(){ /* deliberately disabled in standalone previews */ }
  function restoreAdminArchive(){
    try{
      const saved=JSON.parse(localStorage.getItem(archiveKey)||'null');
      if(!saved)return;
      for(const entry of saved.beneficiaries||[]){
        if(!entry.id||entry.source!=='NGO walk-in')continue;
        const existing=data.beneficiaries.find(b=>b.id===entry.id);
        if(existing)Object.assign(existing,entry);else data.beneficiaries.unshift(entry);
        const number=Number(String(entry.digitalId||'').match(/(\d+)$/)?.[1]||0);
        if(Number.isSafeInteger(number))idSequence=Math.max(idSequence,number);
      }
      for(const entry of saved.partners||[]){
        if(!entry.id||entry.source!=='NGO partner')continue;
        const existing=data.partners.find(p=>p.id===entry.id);
        if(existing)Object.assign(existing,entry);else data.partners.unshift(entry);
      }
    }catch(_){ /* Ignore malformed or unavailable local demo archive. */ }
  }
  const demoStorageKey = 'caregrid_ngowalkin_demo_v3';
  const initialSampleIds = data.beneficiaries.filter(b=>b.source!=='NGO walk-in').map(b=>b.id);
  // sessionStorage is used ONLY for mock preview handoff to beneficiary.html in the same tab.
  // Never save actual document bytes, and never treat browser state as a verified identity database.
  function saveDemo(){
    if(page!=='ngo')return;
    try {
      sessionStorage.setItem(demoStorageKey, JSON.stringify({
        sequence:idSequence,
        records:data.beneficiaries.filter(b=>b.source==='NGO walk-in').map(b=>({
          id:b.id,name:b.name,phone:b.phone,location:b.location,address:b.address,
          cnic:b.cnic,photo:b.photo||'',joined:b.joined,issuedAt:b.issuedAt,
          digitalId:b.digitalId,status:b.status,cardStatus:b.cardStatus,
          documents:b.documents,documentFiles:b.documentFiles,source:b.source
        })),
        sampleCards: Object.fromEntries(data.beneficiaries.filter(b=>initialSampleIds.includes(b.id)).map(b=>[b.id,{digitalId:b.digitalId,cardStatus:b.cardStatus||'Active',issuedAt:b.issuedAt||''}]))
      }));
    } catch(err){toast('Browser demo storage unavailable. The screen will work until refreshed.');}
    publishAdminArchive();
  }
  if(page==='ngo') {
    try {
      const saved=JSON.parse(sessionStorage.getItem(demoStorageKey)||'null');
      if(saved && Array.isArray(saved.records)){
        idSequence=Number(saved.sequence)||5;
        for(const entry of saved.records) if(entry.source==='NGO walk-in' && entry.id && entry.digitalId)
          data.beneficiaries.unshift(entry);
        for(const b of data.beneficiaries){
          const override=saved.sampleCards?.[b.id];
          if(initialSampleIds.includes(b.id) && override){
            if(typeof override.digitalId==='string')b.digitalId=override.digitalId;
            if(['Active','Blocked','Suspended'].includes(override.cardStatus))b.cardStatus=override.cardStatus==='Suspended'?'Blocked':override.cardStatus;
            if(typeof override.issuedAt==='string' && override.issuedAt)b.issuedAt=override.issuedAt;
          }
        }
        // Do not delete the beneficiary record when their card was removed.
      }
    }catch(err){ /* Invalid preview data: ignore. */ }
  }
  // Previous same-origin archive is intentionally not loaded in the isolated portals.
  applySavedDecisions();
  // Migrate any previously created V6 same-tab NGO records into the shared V7 demo register.


  function recentMonths(){
    const now=new Date();
    return [1,2,3].map(n=>{
      const d=new Date(now.getFullYear(),now.getMonth()-n,1);
      return {value:`${d.getFullYear()}-${String(d.getMonth()+1).padStart(2,'0')}`,label:d.toLocaleString('en-US',{month:'long',year:'numeric'})};
    });
  }
  const upload = (name,label,accept='.pdf,.png,.jpg,.jpeg',hint='PDF / JPG / PNG · maximum 5 MB',optional=false) => `<div class="document-upload"><label for="${name}">${label}${optional?' <span class="subtle">(optional)</span>':' <span class="required-star">*</span>'}</label><input type="file" name="${name}" id="${name}" accept="${accept}" ${optional?'':'required'}><span class="field-hint">${hint}</span></div>`;
  function walkInScreen(){
    const months=recentMonths();
    return `${heading('NGO · ASSISTED REGISTRATION','Register a walk-in beneficiary','NGO staff collect identity information, visually check the original CNIC, and review three months of bills. Once this form passes the demo checks, an ID is issued without admin approval.')}
      <div class="walk-note">${I('shield','sm')} <div><strong>NGO-issued digital ID</strong><p>NGO staff must inspect the actual original CNIC. Uploads alone cannot confirm document authenticity. For this frontend demo use fictional details only; files stay in your browser and are not submitted.</p></div></div>
      <form id="walkin-form" class="walkin-grid">
       <section class="card walk-section"><div class="form-heading"><span class="step-number">01</span><div><h2>Personal information</h2><p>Details that will appear on the digital ID card</p></div></div>
         <div class="form-grid">${field('name','Full name (as on CNIC)','e.g. Ahmed Khan')}${field('cnic','CNIC number (13 digits)','12345-1234567-1')}${field('phone','Mobile number','0300 000 0000','','tel')}${field('location','City / district','e.g. Lahore')}
         <div class="field span-full"><label for="address">Full residential address <span class="required-star">*</span></label><textarea id="address" name="address" rows="3" maxlength="250" required placeholder="House, street, area, city"></textarea></div></div>
         ${upload('photo','Beneficiary photograph','.jpg,.jpeg,.png','Portrait photograph · JPG / PNG · maximum 2 MB')}
       </section>
       <section class="card walk-section"><div class="form-heading"><span class="step-number">02</span><div><h2>Identity and supporting documents</h2><p>Documents are required before issuing the card</p></div></div>
         <div class="doc-grid">${upload('cnicFront','Original CNIC — front image')}${upload('cnicBack','Original CNIC — back image')}
         <div class="bill-panel bill-panel-wide"><div class="bills-title"><strong>Electricity bills — last 3 months <span class="required-star">*</span></strong><span>${months.map(m=>m.label).join(' · ')}</span></div>
           <div class="document-upload"><label for="electricityBills">Upload 3 months' bills (one option)</label>
             <input id="electricityBills" name="electricityBills" type="file" accept=".pdf,.jpg,.jpeg,.png,.webp,.heic,.heif,application/pdf,image/*" multiple required aria-describedby="bills-selection-feedback">
             <span class="field-hint">Upload one combined PDF or several images/PDFs · PDF, JPG, PNG, WEBP, HEIC · up to 5 MB per file (max 6 files).</span>
             <p class="bills-feedback" id="bills-selection-feedback" role="status" aria-live="polite">Select one combined PDF or multiple PDF/image files. NGO staff must confirm that all three months are covered.</p>
           </div>
         </div>
         ${upload('salarySlip','Salary slip, if available','.pdf,.png,.jpg,.jpeg','Optional · PDF / JPG / PNG · maximum 5 MB',true)}</div>
       </section>
       <section class="card walk-section walk-checks"><div class="form-heading"><span class="step-number">03</span><div><h2>NGO staff review and issue</h2><p>Manual attestation is required; this is not an automated authenticity check</p></div></div>
         <label class="check-line"><input type="checkbox" name="originalChecked" required> I have physically inspected the beneficiary’s original CNIC and compared it with the copies and applicant.</label>
         <label class="check-line"><input type="checkbox" name="billsChecked" required> I have reviewed the three monthly electricity bills and confirm they belong to this applicant/household.</label>
         <label class="check-line"><input type="checkbox" name="consentChecked" required> The beneficiary has consented to the use of these details for registration and a digital ID.</label>
         <div class="walk-submit"><div><div class="field-hint">No admin approval step for NGO-assisted walk-in registration. The digital card is issued in demo state immediately after submission.</div><p id="draft-status" class="draft-status" role="status">Typing is preserved in this browser tab if the preview refreshes; document files must be selected again after a refresh.</p></div><button class="btn btn-primary" type="submit">${I('check','sm')} Complete registration and issue digital ID</button></div>
       </section>
      </form>`;
  }
  function cardHTML(b){
    const active=!['Blocked','Suspended','Deleted'].includes(b.cardStatus)&&b.status==='Approved'&&Boolean(b.digitalId)&&b.digitalId!=='—';
    const photo=b.photo?`<img src="${esc(b.photo)}" class="card-portrait" alt="Photo of ${esc(b.name)}">`:`<div class="card-portrait empty-portrait">${I('people')}</div>`;
    return `<div class="identity-card ${active?'':'id-suspended'}" role="group" aria-label="Digital ID card for ${esc(b.name)}"><div class="id-card-top"><div class="id-brand"><img src="assets/caregrid-logo.jpg" alt="CareGrid logo"><div><strong>CareGrid</strong><small>NGO BENEFICIARY CARD</small></div></div><span class="card-status">${active?'ACTIVE · DEMO':'BLOCKED · DEMO'}</span></div><div class="id-card-body">${photo}<div class="id-card-info"><span class="id-label">Beneficiary name</span><strong>${esc(b.name)}</strong><span class="id-label">Digital ID</span><strong class="id-code">${esc(b.digitalId||'Not issued')}</strong><span class="id-label">CNIC</span><strong>${esc(displayCnic(b.cnic)||'Not recorded')}</strong><span class="id-label">Residential address</span><p>${esc(b.address||b.location||'Not recorded')}</p></div></div><div class="id-card-footer"><span>Issued ${esc(b.issuedAt||b.joined||'Demo')}</span><strong>FRONTEND PROTOTYPE · NOT VALID FOR VERIFICATION</strong></div></div>`;
  }
  function ngoBeneficiaries(){
    const list=data.beneficiaries.filter(b=>filterSearch(b)&&(state.status==='All'||b.status===state.status));
    return `${heading('NGO MANAGEMENT','Beneficiaries','Register beneficiaries in person, then issue and manage their digital IDs. NGO walk-ins are issued immediately after staff verification.',`<a class="btn btn-primary" href="#walk-in">${I('plus')} New walk-in registration</a>`)}
     <section class="card"><div class="toolbar"><div class="toolbar-left">${searchBox('Search name, ID, city…')}${selectStatus(['All','Approved','Pending'])}</div><div class="toolbar-right"><span class="subtle">${list.length} of ${data.beneficiaries.length} records</span></div></div>${rowTable(['Beneficiary','Record #','Phone','Digital ID','Source','Status','Actions'],list.map(b=>`<tr><td>${person(b.name,b.location)}</td><td class="id-code">${esc(b.id)}</td><td>${esc(b.phone)}</td><td class="id-code">${esc(b.digitalId)}</td><td><small>${esc(b.source||'Existing sample')}</small></td><td>${chip(b.status)}</td><td><div class="table-actions">${b.digitalId&&b.digitalId!=='—'?button('View card','view-card','btn-secondary small',b.id):canIssueCard(b)?button('Issue new card','issue-id','btn-primary small',b.id):''}${b.source==='NGO walk-in'?button('Edit','edit-id','btn-secondary small',b.id):''}</div></td></tr>`))}</section>`;
  }
  function digitalIdsScreen(){
    const allCards=data.beneficiaries.filter(b=>b.status==='Approved'&&Boolean(b.digitalId)&&b.digitalId!=='—');
    const list=allCards.filter(filterSearch);
    const blocked=b=>['Blocked','Suspended'].includes(b.cardStatus);
    return `${heading('NGO · CARD MANAGEMENT','Digital ID cards','Select an approved beneficiary to issue a new card, or manage existing digital IDs.',button(`${I('plus')} Issue new ID`,'open-issue-id','btn-primary'))}
    <div class="grid grid-four" style="margin-bottom:20px">${stat('Issued cards',allCards.length,'Cards currently in this demo','shield','green')}${stat('Active cards',allCards.filter(b=>!blocked(b)).length,'Available to beneficiaries','check','blue')}${stat('Blocked cards',allCards.filter(blocked).length,'Can be unblocked by NGO','clock','amber')}${stat('Eligible for a card',eligibleBeneficiaries().length,'Approved records without an ID','people','purple')}</div>
    <div class="walk-note">${I('alert','sm')} <div><strong>Card management preview:</strong> Block/Unblock and Delete now work for all cards, including the three example cards. Deleting a card leaves the beneficiary registration intact. Editing and reissuing a card remain available for NGO-created records; all changes are local to this browser session.</div></div>
    <section class="card"><div class="toolbar">${searchBox('Find a digital ID or beneficiary…')}</div>${rowTable(['Beneficiary','Digital ID','CNIC','Card status','Operations'],list.map(b=>`<tr><td>${person(b.name,b.location)}</td><td class="id-code">${esc(b.digitalId)}</td><td>${esc(b.cnic||'Demo data unavailable')}</td><td>${chip(blocked(b)?'Blocked':'Active')}</td><td><div class="table-actions">${button('View','view-card','btn-secondary small',b.id)}${b.source==='NGO walk-in'?`${button('Edit','edit-id','btn-secondary small',b.id)}${button('Reissue','reissue-id','btn-secondary small',b.id)}`:''}${button(blocked(b)?'Unblock':'Block','toggle-id',blocked(b)?'btn-primary small':'btn-warning small',b.id)}${button('Delete','delete-id','btn-danger small',b.id)}</div></td></tr>`))}</section>`;
  }
  function openIssueCardDialog(preselectedId=''){
    const candidates=eligibleBeneficiaries();
    if (!candidates.length) {
      modal('Issue new digital ID','Choose a registered, active beneficiary who does not already have a card.',
        `<div class="issue-empty">${I('check')}<strong>No eligible beneficiaries right now</strong><p>All active/approved beneficiaries already have digital ID cards. Register a new walk-in beneficiary, or delete an existing demo card to issue a replacement.</p><a class="btn btn-secondary" href="#walk-in">Open walk-in registration</a></div>`,'','issue-empty-form');
      return;
    }
    const results=candidates.map(b=>`<label class="issue-person" data-eligible-person data-eligible-query="${esc([b.name,b.id,b.location,b.cnic||''].join(' ').toLowerCase())}"><input type="radio" name="selectedBeneficiary" value="${esc(b.id)}" ${b.id===preselectedId?'checked':''} required><span class="issue-avatar">${avatar(b.name)}</span><span class="issue-person-info"><strong>${esc(b.name)}</strong><small>${esc(b.id)} · ${esc(b.location)}</small><small>${esc(b.source||'Existing registration')}</small></span><span class="issue-status">Approved</span></label>`).join('');
    modal('Issue new digital ID',`${candidates.length} approved, active beneficiar${candidates.length===1?'y is':'ies are'} eligible. Select one to generate their demo card.`,
      `<div class="field"><label for="eligible-search">Search registered beneficiaries</label><input type="search" id="eligible-search" placeholder="Search name, record number, or city" autocomplete="off" aria-describedby="eligible-count"></div>
       <p id="eligible-count" class="eligible-count" aria-live="polite">Showing ${candidates.length} eligible beneficiar${candidates.length===1?'y':'ies'}</p>
       <fieldset class="issue-people"><legend>Registered and approved — no digital ID issued</legend>${results}</fieldset>
       <p id="eligible-none" class="issue-no-results" hidden>No beneficiaries match that search.</p>
       <div class="mini-note">Pending registrations and beneficiaries who already have a card are excluded. This is frontend-only issuance using fictional records.</div>`,
      'Generate digital ID','issue-id-form');
  }
  function cardModal(b){
    modal('Beneficiary digital identity',`${esc(b.digitalId||'Not issued')} · ${esc(b.source||'Existing sample')}`,`${cardHTML(b)}<div class="mini-note">This visual card is a demo and not a verifiable credential. Real printing, issuing and verification require secure backend services.</div>`,'','card-preview');
  }
  function ngoPartners(){
    const list=data.partners.filter(p=>filterSearch(p)&&(state.partnerType==='All'||p.type===state.partnerType));
    return `${heading('NGO MANAGEMENT','Service providers','Register restaurants, pharmacies and laboratories for administrator verification.',button(`${I('plus')} Register provider`,'add-partner','btn-primary'))}<section class="card"><div class="toolbar"><div class="toolbar-left">${searchBox('Search organizations…')}<select class="select" aria-label="Filter by provider type" data-partner-type>${['All','Restaurant','Pharmacy','Laboratory'].map(s=>`<option ${state.partnerType===s?'selected':''}>${s}</option>`).join('')}</select></div></div>${rowTable(['Organization','Provider type','City','Contact','Verification','Action'],list.map(p=>`<tr><td><strong>${esc(p.name)}</strong><small>${esc(p.id)}</small></td><td>${esc(p.type)}</td><td>${esc(p.location)}</td><td>${esc(p.contact)}</td><td>${chip(p.status)}</td><td>${button(`${I('eye','sm')} View`,'partner-detail','btn-secondary small',p.id)}</td></tr>`))}</section>`;
  }
  function ngoSponsors(){
    const list=data.sponsors.filter(filterSearch);
    return `${heading('NGO MANAGEMENT','Sponsor accounts','Maintain sponsor contact profiles and contribution overviews.',button(`${I('plus')} Add sponsor`,'add-sponsor','btn-primary'))}<div class="grid grid-three" style="margin-bottom:18px">${stat('Sponsor profiles',data.sponsors.length,'Local demo records','people','green')}${stat('Active sponsors',data.sponsors.filter(a=>a.status==='Active').length,'Contributor accounts','wallet','blue')}${stat('Sample contributions','Rs. 210,000','Illustrative donations only','heart','purple')}</div><section class="card"><div class="toolbar">${searchBox('Search sponsors…')}</div>${rowTable(['Sponsor','Sponsor ID','Support category','Contribution','Status'],list.map(s=>`<tr><td>${person(s.name,s.email)}</td><td class="id-code">${esc(s.id)}</td><td>${esc(s.category)}</td><td><strong>Rs. ${s.contribution.toLocaleString()}</strong></td><td>${chip(s.status==='Active'?'Approved':'Pending')}</td></tr>`))}</section>`;
  }
  function adminOverview(){
    const pending = registrationRequests().filter(a=>a.status==='Pending');
    return `${heading('SYSTEM ADMINISTRATION','Platform overview','Monitor registrations, beneficiaries, services and overall welfare activity.',button(`${I('file')} View reports`,'go-reports','btn-primary'))}<div class="grid grid-four">${stat('Beneficiaries',data.beneficiaries.length,'Preview records in this browser','people','green')}${stat('NGO records',adminOrganizationsData().filter(o=>o.type==='NGO').length,'Organization register','building','blue')}${stat('Food distributed','8,460','Sample meals this month','food','amber')}${stat('Awaiting verification',pending.length,'Registration reviews to complete','clock','purple')}</div><div class="grid section-grid gap-top"><section class="card">${sectionHeader('Welfare activity','Illustrative monthly service trend')}<div class="bar-chart">${[31,47,37,58,51,78,63,85,73,91,68,95].map((v,i)=>`<div class="bar-col"><div class="bar" style="height:${v*1.65}px"></div><span>${['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][i]}</span></div>`).join('')}</div><div class="summary-strip"><span>${I('food','sm')} Food collection</span><span>${I('stethoscope','sm')} Healthcare support</span><span><strong>Demo chart</strong></span></div></section><section class="card">${sectionHeader('Pending verification','Registration requests requiring attention','View all','approvals')}${pending.slice(0,4).map(r=>`<div class="approval-card"><span class="approval-icon">${I('building')}</span><div class="info"><strong>${esc(r.name)}</strong><small>${esc(r.type)} · ${esc(r.submitted)}</small></div>${button('Review','review-request','btn-secondary small',r.id)}</div>`).join('')||'<div class="empty-message">No pending requests.</div>'}<div class="approval-note">Approvals and rejections must be made by an authorized administrator in the live platform.</div></section></div><div class="admin-shortcut" style="margin:20px 0">${I('file','sm')} <div><strong>Central records register</strong><p>Browse all beneficiary, NGO, restaurant, pharmacy and laboratory files from the Admin workspace.</p></div><a href="#organizations" class="btn btn-secondary">Open organization records ${I('arrow','sm')}</a><a href="#beneficiaries" class="btn btn-primary">Open beneficiary register ${I('arrow','sm')}</a></div><div class="grid section-grid gap-top"><section class="card">${sectionHeader('Latest service activity','Recent sample food and healthcare records','See monitoring','monitoring')}${rowTable(['Service','Partner','Status'],[...data.food.slice(0,2).map(f=>`<tr><td><strong>${esc(f.item)}</strong><small>Food donation</small></td><td>${esc(f.name)}</td><td>${chip(f.status==='Collected'?'Approved':'Pending')}</td></tr>`),...data.healthcare.slice(0,2).map(h=>`<tr><td><strong>${esc(h.service)}</strong><small>${esc(h.beneficiary)}</small></td><td>${esc(h.name)}</td><td>${chip(h.status==='Processed'?'Approved':'In progress')}</td></tr>`)])}</section><section class="card">${sectionHeader('Complaints overview','Keep welfare issues moving toward resolution')}<div class="metric-list" style="padding-top:6px;grid-template-columns:repeat(2,1fr)"><div class="metric-tile"><span>New complaints</span><strong>${data.complaints.filter(c=>c.status==='New').length}</strong></div><div class="metric-tile"><span>In progress</span><strong>${data.complaints.filter(c=>c.status==='In progress').length}</strong></div></div><div style="padding:0 20px 24px"><a class="btn btn-secondary" href="#complaints">${I('mailbox')} Manage complaints ${I('arrow','sm')}</a></div></section></div>`;
  }
  function adminApprovals(){
    const list=registrationRequests().filter(r=>filterSearch(r)&&(state.status==='All'||r.status===state.status));
    return `${heading('SYSTEM ADMINISTRATION','Registration requests','Review NGO, restaurant, pharmacy, laboratory and sponsor applications.','')}<section class="card"><div class="toolbar"><div class="toolbar-left">${searchBox('Search requests…')}${selectStatus(['All','Pending','Approved','Rejected'])}</div></div>${rowTable(['Organization','Request ID','Type','Submitted','Decision','Action'],list.map(r=>`<tr><td><strong>${esc(r.name)}</strong><small>${esc(r.location)}</small></td><td class="id-code">${esc(r.id)}</td><td>${esc(r.type)}</td><td>${esc(r.submitted)}</td><td>${chip(r.status)}</td><td>${button(`${I('eye','sm')} Review`,'review-request','btn-secondary small',r.id)}</td></tr>`))}</section>`;
  }
  function entityDocuments(record,kind) {
    if(Array.isArray(record.documentFiles)&&record.documentFiles.length)return record.documentFiles;
    if(kind==='beneficiary'){
      const older=record.documents;
      if(older && typeof older==='object'){
        return [
          {label:'CNIC front',name:older.cnicFront?'Uploaded in an earlier demo version (file unavailable)':'Not provided'},
          {label:'CNIC back',name:older.cnicBack?'Uploaded in an earlier demo version (file unavailable)':'Not provided'},
          ...(Array.isArray(older.bills)?older.bills.map((name,i)=>({label:`Electricity bill ${i+1}`,name})):[]),
          ...(older.salarySlip?[{label:'Salary slip',name:'Provided in earlier demo (file unavailable)'}]:[])
        ];
      }
      return [];
    }
    if(Array.isArray(record.documents))return record.documents.map((name,i)=>({label:`Registration document ${i+1}`,name}));
    return [];
  }
  const decisionKey='caregrid_demo_admin_decisions_v7';
  function savedDecisions(){
    try {const value=JSON.parse(localStorage.getItem(decisionKey)||'{}');return value&&typeof value==='object'?value:{};}
    catch(_){return {};}
  }
  function applySavedDecisions(){
    const decisions=savedDecisions();
    for(const item of [...data.registrations,...data.partners]){
      const d=decisions[item.id];
      if(d&&['Approved','Rejected','Pending'].includes(d.status)){
        item.status=d.status;if(typeof d.reason==='string')item.reason=d.reason;
      }
    }
  }
  function saveDecision(id,status,reason=''){
    const decisions=savedDecisions();decisions[id]={status,reason};
    try{localStorage.setItem(decisionKey,JSON.stringify(decisions));}
    catch(_){toast('Unable to save the demo decision in the browser.');}
    for(const item of [...data.registrations,...data.partners]){
      if(item.id===id){item.status=status;item.reason=reason;}
    }
  }
  function registrationRequests(){
    const added=data.partners.filter(p=>p.source==='NGO partner').map(p=>({
      id:p.id,name:p.name,type:p.type,location:p.location,
      submitted:p.createdAt||'Local demo',status:p.status,
      description:'Provider registration submitted by NGO staff.',contact:p.contact,
      documents:p.documentFiles?.map(d=>d.name)||[],documentFiles:p.documentFiles||[],source:'NGO partner'
    }));
    return [...added,...data.registrations];
  }
  function adminOrganizationsData() {
    const byName=new Map();
    const key=(name,type)=>`${String(type).toLowerCase()}:${String(name).trim().toLowerCase()}`;
    // A registration application is also a record, including when approval is pending.
    for(const r of data.registrations){
      if(!['NGO','Restaurant','Pharmacy','Laboratory'].includes(r.type))continue;
      byName.set(key(r.name,r.type),{id:r.id,name:r.name,type:r.type,location:r.location,
        status:r.status,submitted:r.submitted,description:r.description||'',contact:'Not recorded',
        documents:r.documents||[],documentFiles:r.documentFiles||[],source:'Application'});
    }
    for(const p of data.partners){
      const k=key(p.name,p.type);
      const existing=byName.get(k);
      if(existing){
        byName.set(k,{...existing,contact:p.contact||existing.contact,
          status:p.status,
          id:p.id,source:p.source||existing.source,
          documentFiles:p.documentFiles?.length?p.documentFiles:existing.documentFiles});
      } else byName.set(k,{...p,submitted:p.createdAt||'Demo sample',source:p.source||'Partner directory'});
    }
    return [...byName.values()];
  }
  function adminRecordSummary(){
    const all=adminOrganizationsData();
    return `<div class="grid grid-four" style="margin-bottom:18px">
      ${stat('Beneficiaries',data.beneficiaries.length,'All registration channels','people','green')}
      ${stat('NGOs',all.filter(o=>o.type==='NGO').length,'Organization records','building','blue')}
      ${stat('Pharmacies',all.filter(o=>o.type==='Pharmacy').length,'Service providers','stethoscope','purple')}
      ${stat('Restaurants & labs',all.filter(o=>['Restaurant','Laboratory'].includes(o.type)).length,'Service providers','food','amber')}
    </div>`;
  }
  function adminBeneficiaries(){
    const list=data.beneficiaries.filter(b=>filterSearch(b)&&(state.status==='All'||b.status===state.status));
    return `${heading('SYSTEM ADMINISTRATION','Beneficiary records','Admin records preview with sample beneficiaries and documents. Live NGO records require a protected API.',button(`${I('download')} Export register`,'export-beneficiaries','btn-secondary'))}
    ${adminRecordSummary()}
    <div class="records-info">${I('shield','sm')}<span>Admin can inspect sample beneficiary details and document references. NGO-issued cards do not need second Admin approval. Real cross-portal records require authenticated backend access.</span></div>
    <section class="card"><div class="toolbar"><div class="toolbar-left">${searchBox('Search name, CNIC, record ID, city…')}${selectStatus(['All','Approved','Pending'])}</div></div>${rowTable(['Beneficiary','Registration ID','Digital ID','Registration source','Status','Documents','Action'],list.map(b=>`<tr><td>${person(b.name,b.location)}</td><td class="id-code">${esc(b.id)}</td><td class="id-code">${esc(b.digitalId||'—')}</td><td><small>${esc(b.source||'Existing sample')}</small></td><td>${chip(b.status)}</td><td><span class="doc-count">${entityDocuments(b,'beneficiary').length} files</span></td><td>${button(`${I('eye','sm')} View record`,'admin-beneficiary-record','btn-secondary small',b.id)}</td></tr>`))}</section>`;
  }
  function adminOrganizations(){
    const tabs=['All','NGO','Pharmacy','Restaurant','Laboratory'];
    const all=adminOrganizationsData();
    const filtered=all.filter(o=>(state.organizationType==='All'||o.type===state.organizationType)&&filterSearch(o)&&(state.status==='All'||o.status===state.status));
    return `${heading('SYSTEM ADMINISTRATION','Organization records','View registration records and supporting documents for NGOs, pharmacies, restaurants and medical laboratories.',button(`${I('download')} Export register`,'export-organizations','btn-secondary'))}
    <div class="grid grid-four" style="margin-bottom:18px">${tabs.slice(1).map((type,i)=>stat(type==='NGO'?'NGOs':type==='Laboratory'?'Medical labs':type==='Pharmacy'?'Pharmacies':`${type}s`,all.filter(o=>o.type===type).length,'Independent Admin preview records',['building','stethoscope','food','chart'][i],['green','blue','amber','purple'][i])).join('')}</div>
    <div class="records-info">${I('file','sm')}<span>Document names in sample registrations are references only, not original files. Uploads from the separate NGO portal are not synced in this frontend-only preview.</span></div>
    <section class="card"><div class="record-tabs" role="group" aria-label="Organization type">${tabs.map(t=>`<button type="button" data-action="org-category" data-id="${t}" class="${state.organizationType===t?'active':''}">${t==='Laboratory'?'Medical labs':t==='NGO'?'NGOs':t==='All'?'All organizations':t==='Pharmacy'?'Pharmacies':`${t}s`} <span>${t==='All'?all.length:all.filter(o=>o.type===t).length}</span></button>`).join('')}</div>
    <div class="toolbar"><div class="toolbar-left">${searchBox('Search organizations and records…')}${selectStatus(['All','Approved','Pending','Rejected'])}</div></div>
    ${rowTable(['Organization','Record number','Type','Location','Status','Documents','Action'],filtered.map(o=>`<tr><td><strong>${esc(o.name)}</strong><small>${esc(o.contact||'')}</small></td><td class="id-code">${esc(o.id)}</td><td>${esc(o.type)}</td><td>${esc(o.location)}</td><td>${chip(o.status)}</td><td><span class="doc-count">${entityDocuments(o,'organization').length} files</span></td><td>${button(`${I('eye','sm')} View record`,'admin-organization-record','btn-secondary small',o.id)}</td></tr>`))}</section>`;
  }
  function kv(title,value){return `<div class="record-kv"><span>${esc(title)}</span><strong>${esc(value||'Not recorded')}</strong></div>`;}
  function documentsPanel(entity,kind){
    const docs=entityDocuments(entity,kind);
    const rows=docs.map(d=>`<div class="document-row"><div class="document-row-icon">${I('file','sm')}</div><div class="document-row-name"><strong>${esc(d.label||'Supporting document')}</strong><small title="${esc(d.name)}">${esc(d.name||'No file name recorded')}</small></div><div>${d.local&&d.key?button('Preview','preview-demo-file','btn-primary small',d.key):`<span class="doc-unavailable">${d.key?'Local preview unavailable':'Sample reference only'}</span>`}</div></div>`).join('');
    return `<section class="record-document-panel"><div class="record-subtitle"><strong>Supporting documents</strong><span>${docs.length} listed</span></div>${rows||'<div class="document-placeholder">No document files were stored for this sample record. Actual uploads must be provided through a registered provider/NGO workflow.</div>'}<p class="record-privacy">${I('alert','sm')} File previews are available only for fictional files uploaded into this local browser. Real documents require secure server storage, authorized access, and auditing.</p></section>`;
  }
  function showAdminBeneficiaryRecord(id){
    const b=data.beneficiaries.find(x=>x.id===id);if(!b)return;
    const status=b.digitalId&&b.digitalId!=='—'?(b.cardStatus||'Active'):'Not issued';
    modal('Beneficiary record',`${esc(b.id)} · ${esc(b.source||'Existing sample record')}`,
      `<div class="record-modal"><div class="record-hero">${b.photo?`<img class="record-photo" src="${esc(b.photo)}" alt="Beneficiary portrait">`:avatar(b.name)}<div><h3>${esc(b.name)}</h3><p>${esc(b.location||'Not recorded')} · ${chip(b.status)}</p></div></div><div class="record-kv-grid">
      ${kv('Beneficiary number',b.id)}${kv('Digital ID',b.digitalId==='—'?'Not issued':b.digitalId)}
      ${kv('Card status',status)}${kv('Phone',b.phone)}
      ${kv('CNIC',b.cnic?displayCnic(b.cnic):'Not recorded in sample')}${kv('Registered on',b.joined)}
      ${kv('Full address',b.address||'Not recorded in sample')}${kv('Registration route',b.source||'Existing sample')}
      </div>${b.documents?.originalChecked?'<div class="record-check">Original CNIC inspected by NGO staff (self-attested in demo)</div>':''}
      ${b.documents?.billMonthsReviewed?`<div class="record-check">Bill months recorded: ${esc(b.documents.billMonthsReviewed.join(', '))}</div>`:''}
      ${documentsPanel(b,'beneficiary')}<div class="record-footer">Admin view is read-only. NGO-issued registrations are not sent to an Admin approval queue.</div></div>`,'','admin-beneficiary-detail');
  }
  function showAdminOrganizationRecord(id){
    const o=adminOrganizationsData().find(x=>x.id===id);if(!o)return;
    modal('Organization record',`${esc(o.id)} · ${esc(o.type)}`,
      `<div class="record-modal"><div class="record-hero"><span class="record-type-icon">${I(o.type==='Restaurant'?'food':o.type==='Pharmacy'?'stethoscope':'building')}</span><div><h3>${esc(o.name)}</h3><p>${esc(o.type)} · ${chip(o.status)}</p></div></div>
      <div class="record-kv-grid">${kv('Record number',o.id)}${kv('Category',o.type)}${kv('Location',o.location)}${kv('Contact',o.contact)}${kv('Submitted / added',o.submitted)}${kv('Registration source',o.source)}</div>
      ${o.description?`<div class="record-description">${esc(o.description)}</div>`:''}${documentsPanel(o,'organization')}
      <div class="record-footer">This record is for administrator review only; legal/business verification still requires an authenticated backend.</div></div>`,'','admin-organization-detail');
  }
  async function previewDemoFile(key){
    modal('Document preview','Local-only document viewer · no file is sent to a server',`<div id="document-preview"><p class="preview-wait">Loading selected local document…</p></div>`,'','document-preview');
    try{
      const file=await getDemoFile(key);
      if(!file)throw new Error('The file was not found in browser storage.');
      const mime=file.type||'';
      if(!['application/pdf','image/png','image/jpeg','image/webp','image/heic','image/heif'].includes(mime))throw new Error('This file type cannot be previewed safely.');
      const url=URL.createObjectURL(file);
      const target=document.getElementById('document-preview');
      if(!target){URL.revokeObjectURL(url);return;}
      const body=mime==='application/pdf'?`<iframe title="PDF document preview" src="${url}" class="preview-frame"></iframe>`:`<img alt="Document preview" src="${url}" class="preview-image">`;
      target.innerHTML=`<div class="preview-tools"><span>${esc(file.name||'Local uploaded document')}</span><a href="${url}" download="${esc(file.name||'document')}" class="btn btn-secondary small">${I('download','sm')} Download</a></div>${body}<p class="field-hint">Local demo document, not a verified record. Close this dialog when finished.</p>`;
      currentPreviewUrl=url;
    }catch(error){const target=document.getElementById('document-preview');if(target)target.innerHTML=`<p class="preview-error">${esc(error.message||'Document preview unavailable.')}</p>`;}
  }
  let currentPreviewUrl=null;
  function cleanPreviewUrl(){if(currentPreviewUrl){URL.revokeObjectURL(currentPreviewUrl);currentPreviewUrl=null;}}
  function adminMonitoring(){
    const foodRows=data.food.filter(filterSearch).map(f=>`<tr><td><strong>${esc(f.item)}</strong></td><td>${esc(f.name)}</td><td>${esc(f.quantity)}</td><td>${esc(f.date)}</td><td>${chip(f.status==='Pending'?'Pending':'Approved')}</td></tr>`);
    const healthRows=data.healthcare.filter(filterSearch).map(h=>`<tr><td><strong>${esc(h.service)}</strong></td><td>${esc(h.name)}</td><td>${esc(h.beneficiary)}</td><td>${esc(h.amount)}</td><td>${chip(h.status==='Processed'?'Approved':'In progress')}</td></tr>`);
    return `${heading('SYSTEM ADMINISTRATION','Service monitoring','Review food movement and subsidized healthcare activity in one place.')}<section class="card"><div class="toolbar">${searchBox('Filter activities…')}</div>${sectionHeader('Food donation and distribution','Sample collection and distribution status')}${rowTable(['Food listing','Restaurant','Quantity','Date','Status'],foodRows)}</section><section class="card gap-top">${sectionHeader('Medicine and laboratory activity','Sample subsidy and service records')}${rowTable(['Service','Provider','Beneficiary','Subsidy','Status'],healthRows)}</section>`;
  }
  function adminReports(){
    return `${heading('SYSTEM ADMINISTRATION','Reports & insights','Select a category and date range to preview sample operational statistics.',button(`${I('download')} Export sample CSV`,'download-report','btn-primary'))}<section class="card"><div class="report-controls"><div class="field"><label for="report-category">Report category</label><select id="report-category" data-report-category>${['Welfare summary','Beneficiary registrations','Food redistribution','Healthcare support','Organization activity'].map(s=>`<option ${state.reportCategory===s?'selected':''}>${s}</option>`).join('')}</select></div><div class="field"><label for="report-start">From date</label><input id="report-start" data-report-from type="date" value="${state.reportFrom}"></div><div class="field"><label for="report-end">To date</label><input id="report-end" data-report-to type="date" value="${state.reportTo}"></div>${button(`${I('refresh')} Refresh preview`,'refresh-report','btn-secondary')}</div><div class="divider"></div>${sectionHeader('Report overview','Preview statistics from locally defined sample data')}<div class="metric-list"><div class="metric-tile"><span>Registered beneficiaries</span><strong>${data.beneficiaries.length}</strong></div><div class="metric-tile"><span>Service providers</span><strong>${data.partners.length}</strong></div><div class="metric-tile"><span>Pending requests</span><strong>${registrationRequests().filter(r=>r.status==='Pending').length}</strong></div></div><div class="mini-note" style="margin:0 20px 20px">The selected range and category are UI controls for the prototype. Live report data and actual date-based filtering require backend integration.</div></section><section class="card gap-top">${sectionHeader('Registration summary','Demonstration rows used in sample CSV exports')}${rowTable(['Organization','Type','Submission date','Status'],data.registrations.map(r=>`<tr><td><strong>${esc(r.name)}</strong></td><td>${esc(r.type)}</td><td>${esc(r.submitted)}</td><td>${chip(r.status)}</td></tr>`))}</section>`;
  }
  function complaintInbox(){
    const filtered=data.complaints.filter(c=>filterSearch(c)&&(state.complaintFilter==='All'||c.status===state.complaintFilter));
    if (!filtered.some(c=>c.id===state.selectedComplaint)) state.selectedComplaint=filtered[0]?.id || '';
    const selected=data.complaints.find(c=>c.id===state.selectedComplaint);
    const left = `<section class="card complaint-list"><div class="complaint-list-head"><h2>All complaints <span class="subtle">(${data.complaints.length})</span></h2>${searchBox('Search complaints or references…')}</div><div class="filter-scroll"><div class="mini-filter">${['All','New','In progress','Resolved'].map(s=>`<button data-action="filter-complaints" data-id="${esc(s)}" class="${state.complaintFilter===s?'active':''}">${esc(s)}</button>`).join('')}</div></div>${filtered.map(c=>`<button class="complaint-item ${selected?.id===c.id?'active':''}" data-action="select-complaint" data-id="${esc(c.id)}"><div class="complaint-item-top"><span class="id-code">${esc(c.id)}</span>${chip(c.status)}</div><strong>${esc(c.subject)}</strong><p>${esc(c.text.slice(0,94))}${c.text.length>94?'…':''}</p><div class="complaint-item-foot"><span>${esc(c.name)} · ${esc(c.category)}</span><time>${esc(c.date)}</time></div></button>`).join('')||noResults}</section>`;
    let right='<section class="card"><div class="empty-message">Select a complaint to view its details.</div></section>';
    if(selected) right=`<section class="card complaint-detail"><div class="complaint-detail-head"><div><div class="eyebrow">CASE ${esc(selected.id)}</div><h2>${esc(selected.subject)}</h2><p>Submitted on ${esc(selected.date)} · ${esc(selected.category)}</p></div><div>${chip(selected.status)}</div></div><div class="complaint-meta"><div><span>Beneficiary</span><strong>${esc(selected.name)}</strong></div><div><span>Priority</span><strong>${esc(selected.priority)}</strong></div><div><span>Category</span><strong>${esc(selected.category)}</strong></div><div><span>Reference</span><strong class="id-code">${esc(selected.id)}</strong></div></div><div class="complaint-thread"><div class="timeline-entry"><span class="timeline-avatar">${esc(initials(selected.name))}</span><div class="timeline-body"><div class="timeline-header"><strong>${esc(selected.name)} <span class="subtle">· Beneficiary</span></strong><time>${esc(selected.date)}</time></div><div class="message-bubble">${esc(selected.text)}</div></div></div>${selected.messages.map(m=>`<div class="timeline-entry is-admin"><span class="timeline-avatar admin-avatar">CG</span><div class="timeline-body"><div class="timeline-header"><strong>${esc(m.author)} <span class="subtle">· Administrator</span></strong><time>${esc(m.date)}</time></div><div class="message-bubble">${esc(m.text)}</div></div></div>`).join('')} ${selected.messages.length===0?'<p class="subtle" style="font-size:12px;margin-left:47px">No administrator response yet.</p>':''}</div><form id="reply-form" class="reply-box"><h3>Reply to beneficiary</h3><div class="field"><label for="reply-text">Response message</label><textarea id="reply-text" name="reply" minlength="5" maxlength="1500" required placeholder="Write a clear, helpful response that the beneficiary can read…"></textarea><span class="field-hint">In the prototype, this appears in the conversation only.</span></div><div class="reply-actions"><div class="field"><label for="complaint-status">Update status</label><select name="status" id="complaint-status">${['New','In progress','Resolved'].map(s=>`<option ${selected.status===s?'selected':''}>${s}</option>`).join('')}</select></div><button type="submit" class="btn btn-primary">${I('message','sm')} Send response & update</button></div></form></section>`;
    return `${heading('ADMIN · SUPPORT DESK','Complaint management','Review submissions, reply to beneficiaries, and track their resolution status.')}
    <div class="grid grid-three" style="margin-bottom:18px">${stat('Total complaints',data.complaints.length,'Sample submitted issues','mailbox','blue')}${stat('Open cases',data.complaints.filter(c=>c.status==='New').length,'Waiting for review','clock','amber')}${stat('Resolved cases',data.complaints.filter(c=>c.status==='Resolved').length,'Already addressed','check','green')}</div><div class="complaint-layout">${left}${right}</div>`;
  }
  function render(){
    const section=active();
    const content=page==='ngo'?({overview:ngoOverview,'walk-in':walkInScreen,beneficiaries:ngoBeneficiaries,'digital-ids':digitalIdsScreen,partners:ngoPartners,sponsors:ngoSponsors}[section])():page==='admin'?({overview:adminOverview,approvals:adminApprovals,beneficiaries:adminBeneficiaries,organizations:adminOrganizations,monitoring:adminMonitoring,reports:adminReports,complaints:complaintInbox}[section])():complaintInbox();
    document.getElementById('app').innerHTML=shell(content);
    if (page === 'ngo' && section === 'walk-in') restoreWalkInDraft();
    if(modalType) modalType=null;
  }
  function toast(message){const el=document.getElementById('toast');el.textContent=message;el.classList.add('show');clearTimeout(toast.timer);toast.timer=setTimeout(()=>el.classList.remove('show'),3200)}
  function modal(title,subtitle,contents,submitLabel='Save preview',formId='modal-form'){
    cleanPreviewUrl();modalType=formId;
    const root=document.getElementById('modal-root');
    root.innerHTML=`<div class="modal-backdrop"><div class="modal" role="dialog" aria-modal="true" aria-labelledby="modal-title"><div class="modal-top"><div><h2 id="modal-title">${title}</h2><p>${subtitle}</p></div><button type="button" class="modal-close" aria-label="Close dialog" data-action="close-modal">${I('x','sm')}</button></div><form id="${formId}"><div class="modal-body">${contents}</div><div class="modal-footer"><button type="button" class="btn btn-secondary" data-action="close-modal">Cancel</button>${submitLabel?`<button class="btn btn-primary" type="submit">${submitLabel}</button>`:''}</div></form></div></div>`;
    const target=root.querySelector('input,select,textarea,button');target?.focus();
  }
  const field = (id,label,placeholder='',value='',type='text',required=true) => `<div class="field"><label for="${id}">${label}</label><input id="${id}" name="${id}" type="${type}" placeholder="${esc(placeholder)}" value="${esc(value)}" ${required?'required':''} ${type==='tel'?'pattern="[0-9+() -]{10,18}"':''} maxlength="120"></div>`;
  const choose = (id,label,options,selected='') => `<div class="field"><label for="${id}">${label}</label><select id="${id}" name="${id}">${options.map(s=>`<option ${s===selected?'selected':''}>${esc(s)}</option>`).join('')}</select></div>`;
  function openModal(action,id){
    if(action==='edit-beneficiary'){
      const b=data.beneficiaries.find(b=>b.id===id);if(!b)return;
      modal('Edit sample beneficiary','This is a demo record. For full NGO document-based registration, use Walk-in registration.',`<input type="hidden" name="recordId" value="${esc(b.id)}"><div class="form-grid">${field('name','Full name','e.g. Ayesha Malik',b.name)}${field('phone','Phone number','0300 000 0000',b.phone,'tel')}${field('location','City','e.g. Lahore',b.location)}</div>`,'Update record','edit-beneficiary-form');
    } else if(action==='add-partner'){
      modal('Register service provider','Send a sample partnership request for verification.',`<div class="form-grid">${field('name','Organization name','e.g. Community Health Lab')}${choose('type','Provider category',['Restaurant','Pharmacy','Laboratory'])}${field('location','City / district','e.g. Lahore')}${field('contact','Contact number','0300 000 0000','','tel')}<div class="field span-full"><label for="partner-doc">Supporting document (UI preview)</label><input type="file" id="partner-doc" accept=".pdf,.png,.jpg,.jpeg" required><span class="field-hint">Fictional demo document only. Stored locally in your browser for the Admin preview; never uploaded to a server.</span></div></div>`,'Add pending request','partner-form');
    } else if(action==='add-sponsor'){
      modal('Add sponsor profile','Create a sample sponsor record. No credentials are generated.',`<div class="form-grid">${field('name','Sponsor name','Name or organization')}${field('email','Email','contact@example.com','','email')}${choose('category','Support category',['Food distribution','Medical support','General welfare'])}<div class="field"><label>Account access</label><div class="mini-note">Login setup requires the future authentication backend.</div></div></div>`,'Add sponsor profile','sponsor-form');
    } else if(action==='partner-detail'){
      const p=data.partners.find(p=>p.id===id);if(!p)return;
      modal('Provider profile',`Reference: ${esc(p.id)}`,`<div class="stack"><div class="metric-tile"><span>Organization</span><strong>${esc(p.name)}</strong></div><div class="metric-tile"><span>Category and location</span><strong>${esc(p.type)} · ${esc(p.location)}</strong></div><div class="metric-tile"><span>Verification</span><strong>${chip(p.status)}</strong></div><div class="mini-note">Documents and approval history will be populated after backend integration.</div></div>`,'','partner-info');
    } else if(action==='review-request'){
      const r=registrationRequests().find(r=>r.id===id);if(!r)return;
      modal('Review registration',`${esc(r.id)} · ${esc(r.type)} application`,`<div class="stack"><div class="metric-tile"><span>Applicant</span><strong>${esc(r.name)}</strong></div><div class="form-grid"><div class="metric-tile"><span>City</span><strong>${esc(r.location)}</strong></div><div class="metric-tile"><span>Submitted</span><strong>${esc(r.submitted)}</strong></div></div><div class="mini-note">${esc(r.description)}</div>${documentsPanel(r,'organization')}<div class="field"><label>Current decision</label>${chip(r.status)}</div>${r.status==='Pending'?`<div class="form-grid"><button type="button" class="btn btn-primary" data-action="approve-request" data-id="${esc(r.id)}">${I('check','sm')} Approve sample</button><button type="button" class="btn btn-danger" data-action="reject-request" data-id="${esc(r.id)}">${I('x','sm')} Reject sample</button></div>`:r.reason?`<div class="mini-note">Rejection reason: ${esc(r.reason)}</div>`:''}</div>`,'','request-info');
    } else if(action==='reject-request'){
      modal('Reject registration','A reason is required for rejecting an application.',`<input type="hidden" name="recordId" value="${esc(id)}"><div class="field"><label for="rejectionReason">Reason for rejection</label><textarea id="rejectionReason" name="reason" required minlength="10" maxlength="500" rows="4" placeholder="Explain what the applicant should correct…"></textarea></div>`,'Reject sample request','reject-form');
    }
  }
  function syncInput(el,prop){const val=el.value;state[prop]=val;render();const updated=document.querySelector(`[${el.dataset.search!==undefined?'data-search':el.dataset.status!==undefined?'data-status':'data-partner-type'}]`);if(updated&&'selectionStart' in updated){updated.focus();updated.setSelectionRange(val.length,val.length)}}
  document.addEventListener('input',e=>{
    if (e.target.matches('[data-search]')) syncInput(e.target,'search');
    if (e.target.matches('#eligible-search')) {
      const query=e.target.value.toLowerCase().trim();
      const rows=Array.from(document.querySelectorAll('[data-eligible-person]'));
      let showing=0;
      for (const row of rows) {
        const matches=(row.dataset.eligibleQuery||'').includes(query);
        row.hidden=!matches;
        if (!matches && row.querySelector('input[type=radio]')?.checked) row.querySelector('input[type=radio]').checked=false;
        if (matches) showing++;
      }
      const count=document.getElementById('eligible-count');
      if (count) count.textContent=`Showing ${showing} eligible beneficiar${showing===1?'y':'ies'}`;
      const none=document.getElementById('eligible-none');
      if (none) none.hidden=showing!==0;
    }
    if (e.target.closest('#walkin-form') && e.target.type !== 'file') saveWalkInDraft(e.target.form);
  });
  document.addEventListener('change',e=>{
    if (e.target.matches('#walkin-form #electricityBills')) updateBillsFeedback(e.target);
    if (e.target.closest('#walkin-form') && e.target.type !== 'file') saveWalkInDraft(e.target.form);
    if(e.target.matches('[data-status]')){state.status=e.target.value;render()}
    if(e.target.matches('[data-partner-type]')){state.partnerType=e.target.value;render()}
    if(e.target.matches('[data-report-category]'))state.reportCategory=e.target.value;
    if(e.target.matches('[data-report-from]'))state.reportFrom=e.target.value;
    if(e.target.matches('[data-report-to]'))state.reportTo=e.target.value;
  });
  document.addEventListener('click',e=>{
    if(e.target.classList.contains('modal-backdrop')){cleanPreviewUrl();document.getElementById('modal-root').innerHTML='';modalType=null;return}
    const el=e.target.closest('[data-action]');if(!el)return;
    const action=el.dataset.action,id=el.dataset.id;
    if(action==='menu'){document.body.classList.toggle('sidebar-open');return}
    if(action==='close-modal'){cleanPreviewUrl();document.getElementById('modal-root').innerHTML='';modalType=null;return}
    if(action==='go-walk-in'){location.hash='walk-in';return}
    if(action==='org-category'){state.organizationType=id;state.search='';state.status='All';render();return}
    if(action==='admin-beneficiary-record'){showAdminBeneficiaryRecord(id);return}
    if(action==='admin-organization-record'){showAdminOrganizationRecord(id);return}
    if(action==='preview-demo-file'){previewDemoFile(id);return}
    if(action==='export-beneficiaries'||action==='export-organizations'){
      const records=action==='export-beneficiaries'?
        [['ID','Name','CNIC (masked)','Phone','City','Source','Status','Digital ID','Documents'],...data.beneficiaries.map(b=>[b.id,b.name,b.cnic?`*****${String(b.cnic).slice(-4)}`:'',b.phone,b.location,b.source||'Existing sample',b.status,b.digitalId,entityDocuments(b,'beneficiary').length])]:
        [['ID','Organization','Type','Location','Contact','Status','Documents'],...adminOrganizationsData().map(o=>[o.id,o.name,o.type,o.location,o.contact,o.status,entityDocuments(o,'organization').length])];
      const csv=records.map(row=>row.map(item=>`"${String(item??'').replaceAll('"','""')}"`).join(',')).join('\r\n');
      const blobUrl=URL.createObjectURL(new Blob([csv],{type:'text/csv;charset=utf-8'}));
      const a=document.createElement('a');a.href=blobUrl;a.download=action==='export-beneficiaries'?'caregrid_demo_beneficiaries.csv':'caregrid_demo_organizations.csv';a.click();setTimeout(()=>URL.revokeObjectURL(blobUrl),1000);
      toast('Exported demo register CSV (not a secure official record).');return;
    }
    if(action==='open-issue-id'){openIssueCardDialog();return}
    if(action==='issue-id'){
      const beneficiary=data.beneficiaries.find(b=>b.id===id);
      if(!canIssueCard(beneficiary)){toast('Select an approved beneficiary without a digital ID.');return}
      openIssueCardDialog(id);return;
    }
    if(['view-card','edit-id','toggle-id','reissue-id','delete-id'].includes(action)){
      const b=data.beneficiaries.find(b=>b.id===id);if(!b){toast('Beneficiary not found.');return}
      if(action==='view-card'){cardModal(b);return}
      if(['edit-id','reissue-id'].includes(action) && b.source!=='NGO walk-in'){toast('Editing and reissuing existing sample records is not available in this prototype.');return}
      if(action==='edit-id'){
        modal('Update beneficiary & digital ID',`NGO-issued · ${esc(b.digitalId)}`,`<input type="hidden" name="recordId" value="${esc(b.id)}"><div class="form-grid">${field('name','Full name','',b.name)}${field('phone','Mobile number','',b.phone,'tel')}${field('cnic','CNIC number','',b.cnic)}${field('location','City','',b.location)}<div class="field span-full"><label for="address">Residential address</label><textarea name="address" id="address" rows="3" required maxlength="250">${esc(b.address||'')}</textarea></div></div><div class="field">${upload('photo','Replace portrait photograph','.jpg,.jpeg,.png','Optional, up to 2 MB',true)}</div><div class="mini-note">The digital ID stays the same on an ordinary profile edit.</div>`,'Save beneficiary changes','edit-id-form');return;
      }
      if(action==='toggle-id'){
        b.cardStatus=['Blocked','Suspended'].includes(b.cardStatus)?'Active':'Blocked';saveDemo();render();toast(`Demo digital ID ${b.cardStatus.toLowerCase()}.`);return;
      }
      if(action==='reissue-id'){
        if(!confirm('Reissue this ID? The previous demo ID will be replaced.'))return;
        b.digitalId=sampleId();b.issuedAt=new Date().toLocaleDateString('en-GB');b.cardStatus='Active';saveDemo();render();cardModal(b);return;
      }
      if(action==='delete-id'){
        if(!confirm(`Delete ${b.name}'s digital ID from this demo? Their beneficiary registration will be kept.`))return;
        b.digitalId='—';b.cardStatus='Deleted';saveDemo();render();toast('Digital card deleted from demo. Beneficiary record kept.');return;
      }
    }
    if(action==='notification'){toast('Notifications are visual only in this prototype.');return}
    if(['add-beneficiary','edit-beneficiary','add-partner','add-sponsor','partner-detail','review-request','reject-request'].includes(action)){openModal(action,id);return}
    if(action==='approve-request'){const req=registrationRequests().find(r=>r.id===id);if(req){saveDecision(req.id,'Approved');render();toast(`${req.name}: sample request approved locally.`)}return}
    if(action==='filter-complaints'){state.complaintFilter=id;render();return}
    if(action==='select-complaint'){state.selectedComplaint=id;render();return}
    if(action==='go-reports'){location.hash='reports';return}
    if(action==='refresh-report'){if(state.reportFrom>state.reportTo){toast('Start date must be before end date.');return}toast('Sample report preview refreshed (no live data).');return}
    if(action==='download-report'){
      if(state.reportFrom>state.reportTo){toast('Start date must be before end date.');return}
      const rows=[['Report category',state.reportCategory],['From',state.reportFrom],['To',state.reportTo],[],['Reference','Organization','Type','Submitted','Status'],...data.registrations.map(r=>[r.id,r.name,r.type,r.submitted,r.status])];
      const csv=rows.map(row=>row.map(cell=>`"${String(cell??'').replaceAll('"','""')}"`).join(',')).join('\r\n');
      const url=URL.createObjectURL(new Blob([csv],{type:'text/csv;charset=utf-8'}));const a=document.createElement('a');a.href=url;a.download='caregrid_sample_report.csv';a.click();setTimeout(()=>URL.revokeObjectURL(url),1000);toast('Exported sample CSV (not a live report).');return;
    }
  });
  function validUpload(file,photo=false){
    const ext=file?.name?.toLowerCase().split('.').pop();
    const types=photo?['jpg','jpeg','png']:['pdf','jpg','jpeg','png'];
    return file && types.includes(ext) && file.size>0 && file.size<=(photo?2:5)*1024*1024;
  }
  function compactPortrait(file){
    return new Promise((resolve,reject)=>{
      const reader=new FileReader();
      reader.onerror=()=>reject(new Error('Cannot read portrait'));
      reader.onload=()=>{
        const img=new Image();img.onerror=()=>reject(new Error('Invalid portrait image'));
        img.onload=()=>{
          const canvas=document.createElement('canvas');canvas.width=240;canvas.height=240;
          const ctx=canvas.getContext('2d');if(!ctx){reject(new Error('Image processing unavailable'));return}
          const size=Math.min(img.width,img.height);
          ctx.drawImage(img,(img.width-size)/2,(img.height-size)/2,size,size,0,0,240,240);
          resolve(canvas.toDataURL('image/jpeg',.74));
        };img.src=String(reader.result);
      };reader.readAsDataURL(file);
    });
  }
  document.addEventListener('submit',async e=>{
    e.preventDefault();const form=e.target;const fd=new FormData(form);const get=n=>String(fd.get(n)||'').trim();
    if(form.id==='issue-id-form'){
      if(page!=='ngo'){toast('Only NGO staff can issue cards in this demo.');return}
      const id=get('selectedBeneficiary');
      const b=data.beneficiaries.find(b=>b.id===id);
      if(!canIssueCard(b)){toast('Select an active, approved beneficiary who does not have a card.');return}
      b.digitalId=sampleId();
      b.cardStatus='Active';
      b.issuedAt=new Date().toLocaleDateString('en-GB');
      saveDemo();
      try{sessionStorage.setItem('caregrid_selected_beneficiary_v3',b.digitalId)}catch(_){/* Demo storage may be unavailable */}
      if(active()!=='digital-ids') history.replaceState(null,'','#digital-ids');
      state.search='';
      render();cardModal(b);
      toast(`${b.name}: demo digital ID generated successfully.`);
      return;
    }
    if(form.id==='walkin-form'){
      const cnic=get('cnic').replace(/\D/g,'');
      if(!/^\d{13}$/.test(cnic)){toast('CNIC must contain exactly 13 digits.');return}
      if(data.beneficiaries.some(b=>(b.cnic||'').replace(/\D/g,'')===cnic)){toast('A beneficiary with this CNIC is already registered in this demo.');return}
      const fileKeys=['photo','cnicFront','cnicBack'];
      for(const key of fileKeys){if(!validUpload(form.elements[key].files[0],key==='photo')){toast(`Upload a valid ${key} file within its size limit.`);return}}
      const bills = Array.from(form.elements.electricityBills.files || []);
      const billsError = validateBillFiles(bills);
      if (billsError) {
        updateBillsFeedback(form.elements.electricityBills);
        toast(billsError);
        form.elements.electricityBills.focus();
        return;
      }
      const optional=form.elements.salarySlip.files[0];
      if(optional && !validUpload(optional)){toast('Salary slip must be PDF/JPG/PNG, up to 5 MB.');return}
      if(!form.elements.originalChecked.checked || !form.elements.billsChecked.checked || !form.elements.consentChecked.checked){toast('All three NGO staff confirmations are required.');return}
      if(!/^[0-9+() -]{10,18}$/.test(get('phone'))){toast('Enter a valid mobile number.');return}
      const submit=form.querySelector('[type=submit]');submit.disabled=true;submit.textContent='Issuing demo ID…';
      try{
        const photo=await compactPortrait(form.elements.photo.files[0]);
        const digitalId=sampleId();
        const beneficiaryNumber='BEN-NGO-'+String(idSequence).padStart(5,'0');
        const documentFiles=[];
        // The original portrait is only used to generate a small card photo.
        // Other documents are saved in this browser's IndexedDB for the Admin demo viewer.
        documentFiles.push(await storeDemoFile(beneficiaryNumber,'Original CNIC front',form.elements.cnicFront.files[0]));
        documentFiles.push(await storeDemoFile(beneficiaryNumber,'Original CNIC back',form.elements.cnicBack.files[0]));
        for(let i=0;i<bills.length;i++)documentFiles.push(await storeDemoFile(beneficiaryNumber,`Electricity bill ${i+1}`,bills[i],i));
        if(optional)documentFiles.push(await storeDemoFile(beneficiaryNumber,'Salary slip (optional)',optional));
        const b={id:beneficiaryNumber,digitalId,
          name:get('name'),cnic,phone:get('phone'),location:get('location'),address:get('address'),
          photo,source:'NGO walk-in',status:'Approved',cardStatus:'Active',
          joined:new Date().toLocaleDateString('en-GB'),issuedAt:new Date().toLocaleDateString('en-GB'),
          documentFiles,documents:{cnicFront:true,cnicBack:true,
            bills:bills.map(file=>file.name),billMonthsReviewed:recentMonths().map(m=>m.value),
            salarySlip:Boolean(optional),originalChecked:true}
        };
        data.beneficiaries.unshift(b);
        saveDemo();clearWalkInDraft();history.replaceState(null,'','#digital-ids');render();
        try{sessionStorage.setItem('caregrid_selected_beneficiary_v3',b.digitalId)}catch(_){}
        cardModal(b);toast('NGO walk-in registered and demo ID issued. No admin queue.');
      }catch(err){toast('Unable to process portrait. Choose a valid JPG or PNG photo.');submit.disabled=false;submit.textContent='Complete registration and issue digital ID'}
      return;
    }
    if(form.id==='edit-id-form'){
      const b=data.beneficiaries.find(x=>x.id===get('recordId'));
      if(!b || b.source!=='NGO walk-in'){toast('NGO-issued record not found.');return}
      const digits=get('cnic').replace(/\D/g,'');
      if(!/^\d{13}$/.test(digits)){toast('CNIC must contain 13 digits.');return}
      if(data.beneficiaries.some(x=>x.id!==b.id&&(x.cnic||'').replace(/\D/g,'')===digits)){toast('This CNIC is already registered.');return}
      const photo=form.elements.photo.files[0];
      if(photo&&!validUpload(photo,true)){toast('Portrait must be a JPG/PNG image up to 2 MB.');return}
      let newPhoto=b.photo;
      if(photo){try{newPhoto=await compactPortrait(photo)}catch(_){toast('Cannot process the selected photo.');return}}
      Object.assign(b,{name:get('name'),phone:get('phone'),cnic:digits,address:get('address'),location:get('location'),photo:newPhoto});
      saveDemo();render();toast('NGO beneficiary profile updated locally.');return;
    }
    if(form.id==='edit-beneficiary-form'){
      const phone=get('phone');if(!/^[0-9+() -]{10,18}$/.test(phone)){toast('Please enter a valid phone number.');return}
      const editing=form.id==='edit-beneficiary-form';const b=editing?data.beneficiaries.find(x=>x.id===get('recordId')):null;
      if(editing && !b){toast('This record was not found.');return}
      if(b){b.name=get('name');b.phone=phone;b.location=get('location');}
      else{const newId='BEN-'+String(1001+data.beneficiaries.length);data.beneficiaries.unshift({id:newId,name:get('name'),phone,location:get('location'),status:'Pending',digitalId:'—',joined:'22 Nov 2026'})}
      render();toast(editing?'Beneficiary preview updated.':'Sample beneficiary added as pending.');return;
    }
    if(form.id==='partner-form'){
      const file=document.getElementById('partner-doc')?.files?.[0];if(!file){toast('Select a supporting document.');return}
      if(file.size>5*1024*1024){toast('Choose a file smaller than 5 MB.');return}
      const id='ORG-'+(205+data.partners.length);
      if(!validUpload(file)){toast('Select a PDF, JPG or PNG up to 5 MB.');return}
      const documentFiles=[await storeDemoFile(id,'Business registration document',file)];
      const p={id,name:get('name'),type:get('type'),location:get('location'),contact:get('contact'),
        status:'Pending',source:'NGO partner',createdAt:new Date().toLocaleDateString('en-GB'),documentFiles};
      data.partners.unshift(p);publishAdminArchive();render();toast('Provider added to local pending list. Admin can view the demo document.');return;
    }
    if(form.id==='sponsor-form'){
      data.sponsors.unshift({id:'SP-'+(303+data.sponsors.length),name:get('name'),email:get('email'),category:get('category'),contribution:0,status:'Pending'});render();toast('Sponsor sample profile added locally.');return;
    }
    if(form.id==='reject-form'){
      const r=registrationRequests().find(x=>x.id===get('recordId'));if(!r)return;
      if(get('reason').length<10){toast('Provide a reason of at least 10 characters.');return}
      saveDecision(r.id,'Rejected',get('reason'));render();toast('Sample registration rejected with a reason.');return;
    }
    if(form.id==='reply-form'){
      const c=data.complaints.find(x=>x.id===state.selectedComplaint);if(!c)return;
      if(get('reply').length<5){toast('Enter a meaningful response.');return}
      c.messages.push({author:'CareGrid Support',date:'22 Nov 2026 · demo',text:get('reply')});c.status=get('status');render();toast('Demo response added and status updated locally.');return;
    }
  });
  document.addEventListener('keydown',e=>{if(e.key==='Escape'&&modalType){cleanPreviewUrl();document.getElementById('modal-root').innerHTML='';modalType=null}});
  window.addEventListener('hashchange',()=>{state.search='';state.status='All';document.body.classList.remove('sidebar-open');render()});
  render();
})();
