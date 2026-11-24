/* CareGrid multi-portal assistant — LOCAL DEMO, no backend, no actual RAG.
   Same-origin browser storage connects the role previews in one browser profile.
   Do not enter real beneficiary, patient, identity or medical data. */
(() => {
  'use strict';
  const KEYS = {
    faqs: 'caregrid.demo.assistant.faqs.v1',
    criteria: 'caregrid.demo.assistant.criteria.v1',
    history: 'caregrid.demo.assistant.history.v1'
  };
  const ROLES = ['ngo','admin','lab','pharmacy'];
  const ROLE_LABELS = {ngo:'NGO',admin:'Admin',lab:'Lab partner',pharmacy:'Pharmacy'};
  const DEFAULT_FAQS = [
    {id:'faq-1',question:'How do I register a beneficiary?',answer:'In the NGO workspace, open Walk-in Registration. Check the original identity documents and consent before creating a DEMO beneficiary record. Real registration requires a secure backend.',keywords:'beneficiary,register,registration,walk in,cnic',roles:['ngo','admin'],enabled:true,category:'Registration'},
    {id:'faq-2',question:'How does the Digital ID work?',answer:'The Digital ID is a visual DEMO card. Secure issuance, QR validation and counter verification are NOT active. Approved organizations will need a signed credential and real verification API.',keywords:'digital id,id card,verify,qr,identity,card',roles:ROLES,enabled:true,category:'Digital ID'},
    {id:'faq-3',question:'How can a laboratory handle a request?',answer:'Open Lab Requests to inspect sample appointments and prescriptions. Real approval, scheduling, OCR verification and reports require backend services. Do not use sample records for patient care.',keywords:'lab,test,appointment,diagnostic,cbc,request,report',roles:['lab','ngo','admin'],enabled:true,category:'Laboratory'},
    {id:'faq-4',question:'How is medicine support processed?',answer:'Pharmacy previews can show example prescriptions and subsidy amounts, but must verify beneficiary eligibility and medicine dispensing through a real backend before processing any purchase.',keywords:'pharmacy,medicine,prescription,dispense,medication,drug',roles:['pharmacy','ngo','admin'],enabled:true,category:'Pharmacy'},
    {id:'faq-5',question:'How do I handle complaints?',answer:'Beneficiaries can create demo complaint references. NGO and Admin support workflows need authenticated access to real requests before any staff action is considered complete.',keywords:'complaint,feedback,issue,support,help',roles:ROLES,enabled:true,category:'Support'},
    {id:'faq-6',question:'Who manages assistant questions and criteria?',answer:'Open the Admin portal Assistant Control page to add or edit demo FAQs, keywords, role visibility, matching threshold and fallback wording. Changes are stored in this browser only.',keywords:'admin,assistant,criteria,rule,faq,questions,settings,history',roles:ROLES,enabled:true,category:'Assistant'},
    {id:'faq-7',question:'Are the values live?',answer:'No. The displayed identity cards, subsidies, account balances and lab requests are fictional prototype data. CareGrid does not currently have a connected production data service.',keywords:'live,balance,remaining,eligibility,account,amount,subsidy',roles:ROLES,enabled:true,category:'Demo data'}
  ];
  const DEFAULT_CRITERIA = {
    minimumMatches: 1,
    maxQuestionLength: 500,
    fallback: 'I can explain this CareGrid demo, but there is no verified answer for that request. Ask the relevant NGO, Admin or partner team. No real records are accessible.',
    prohibited: 'password,otp,pin,secret key',
    retainHistory: true
  };
  const clone = x => JSON.parse(JSON.stringify(x));
  function load(key, fallback) {
    try {
      const raw = localStorage.getItem(key);
      return raw ? JSON.parse(raw) : clone(fallback);
    } catch (_) { return clone(fallback); }
  }
  function save(key, value) {
    try { localStorage.setItem(key, JSON.stringify(value)); return true; }
    catch (_) { return false; }
  }
  const sanitize = value => String(value ?? '')
    .replace(/\b\d{5}-?\d{7}-?\d\b/g,'[redacted CNIC]')
    .replace(/[\w.+-]+@[\w.-]+\.[A-Za-z]{2,}/g,'[redacted email]')
    .replace(/\b(?:\+92|0)3\d{2}[- ]?\d{7}\b/g,'[redacted phone]')
    .replace(/\b\d{11,}\b/g,'[redacted number]');
  function cleanFaq(x) {
    return {
      id: String(x.id || ('faq-'+Date.now())),
      question: String(x.question || '').slice(0,180),
      answer: String(x.answer || '').slice(0,1500),
      keywords: String(x.keywords || '').slice(0,500),
      roles: Array.isArray(x.roles) ? x.roles.filter(r=>ROLES.includes(r)) : ROLES,
      enabled: x.enabled !== false,
      category: String(x.category||'General').slice(0,65)
    };
  }
  function getFaqs() {
    const a=load(KEYS.faqs,DEFAULT_FAQS);
    return Array.isArray(a) ? a.map(cleanFaq) : clone(DEFAULT_FAQS);
  }
  function setFaqs(items) { return save(KEYS.faqs,items.map(cleanFaq).slice(0,200)); }
  function getCriteria() {
    const o=load(KEYS.criteria,DEFAULT_CRITERIA);
    return {...DEFAULT_CRITERIA,...o, minimumMatches:Math.min(5,Math.max(1,Number(o.minimumMatches)||1)), maxQuestionLength:Math.min(1000,Math.max(100,Number(o.maxQuestionLength)||500))};
  }
  function setCriteria(o) { return save(KEYS.criteria,{...getCriteria(),...o}); }
  function getHistory() {
    const a=load(KEYS.history,[]);
    return Array.isArray(a) ? a.slice(-500) : [];
  }
  function setHistory(a) { return save(KEYS.history,a.slice(-500)); }
  function normalize(s) { return String(s).toLowerCase().replace(/[^a-z0-9\s]/g,' ').replace(/\s+/g,' ').trim(); }
  function answer(question,role) {
    const criteria=getCriteria(),clean=sanitize(question).slice(0,criteria.maxQuestionLength), q=normalize(clean);
    const forbidden=String(criteria.prohibited||'').split(',').map(x=>normalize(x)).filter(Boolean);
    if(forbidden.some(x=>q.includes(x)))return {text:'Please do not share passwords, one-time codes or confidential credentials in the demo assistant.',source:'Demo safety rule'};
    if(!q)return {text:'Enter a question about CareGrid services.',source:'Demo'};
    let best=null,score=0;
    for(const faq of getFaqs()){
      if(!faq.enabled||!faq.roles.includes(role))continue;
      const words=faq.keywords.split(',').map(normalize).filter(Boolean);
      let n=words.reduce((acc,k)=>acc+((q.includes(k)||k.split(' ').some(w=>w.length>3&&q.split(' ').includes(w)))?1:0),0);
      const title=normalize(faq.question);
      if(q===title)n+=4;
      if(n>score){best=faq;score=n;}
    }
    if(best&&score>=criteria.minimumMatches)return {text:best.answer,source:'Admin-approved demo FAQ · '+best.category};
    return {text:String(criteria.fallback||DEFAULT_CRITERIA.fallback),source:'Demo fallback · No verified answer'};
  }
  function storeTurn({role,sessionId,question,response}) {
    const c=getCriteria();if(!c.retainHistory)return;
    const h=getHistory();
    h.push({id:'cg-'+Date.now()+'-'+Math.random().toString(36).slice(2,8),sessionId:String(sessionId),role:ROLES.includes(role)?role:'ngo',date:new Date().toISOString(),question:sanitize(question).slice(0,1000),answer:sanitize(response.text).slice(0,1500),source:response.source});
    setHistory(h);
  }
  const API={
    ROLES,ROLE_LABELS,DEFAULT_FAQS:clone(DEFAULT_FAQS),DEFAULT_CRITERIA:clone(DEFAULT_CRITERIA),
    getFaqs,setFaqs,getCriteria,setCriteria,getHistory,
    clearHistory:()=>save(KEYS.history,[]),
    resetDefaults:()=>{setFaqs(DEFAULT_FAQS);setCriteria(DEFAULT_CRITERIA);},
    answer,storeTurn,sanitize
  };
  window.CareGridDemoChat=API;

  const role=document.body.dataset.caregridRole;
  if(!ROLES.includes(role))return;
  const script=document.currentScript;
  if(script){
    const link=document.createElement('link');
    link.rel='stylesheet';link.href=new URL('assistant.css',script.src).href;
    document.head.appendChild(link);
  }
  const box=document.createElement('div');
  box.className='cg-assistant';
  box.innerHTML=`
    <button type="button" class="cg-chat-launcher" aria-label="Open CareGrid assistant" aria-expanded="false"><span aria-hidden="true">✦</span> Ask CareGrid</button>
    <section class="cg-chat-window" role="dialog" aria-label="CareGrid help assistant" hidden>
      <header class="cg-chat-head">
        <div><span class="cg-chat-name">✦ CareGrid Assistant</span><small>Information guide · ${ROLE_LABELS[role]} · DEMO</small></div>
        <button type="button" class="cg-chat-close" aria-label="Close assistant">×</button>
      </header>
      <div class="cg-chat-notice">Local FAQ prototype only. Not live AI or verified records. Do not enter medical, identity or financial information.</div>
      <div class="cg-chat-messages" aria-live="polite"></div>
      <div class="cg-chat-suggestions"></div>
      <form class="cg-chat-form"><label class="cg-sr" for="caregrid-chat-input">Your question</label><input id="caregrid-chat-input" name="question" maxlength="500" autocomplete="off" placeholder="Ask about CareGrid services…" required><button type="submit">Send</button></form>
      <footer class="cg-chat-footer"><span>Answers configured by Admin (local demo)</span><button type="button" class="cg-chat-reset">New conversation</button></footer>
    </section>`;
  document.body.appendChild(box);
  const launcher=box.querySelector('.cg-chat-launcher');
  const windowEl=box.querySelector('.cg-chat-window');
  const messages=box.querySelector('.cg-chat-messages');
  const suggestions=box.querySelector('.cg-chat-suggestions');
  const form=box.querySelector('.cg-chat-form');
  const input=form.elements.question;
  let sessionId='session-'+Date.now().toString(36);
  function append(sender,text,source){
    const row=document.createElement('div');row.className='cg-msg '+sender;
    const msg=document.createElement('div');msg.className='cg-msg-bubble';msg.textContent=text;row.appendChild(msg);
    if(source){const small=document.createElement('small');small.textContent=source;row.appendChild(small);}
    messages.appendChild(row);messages.scrollTop=messages.scrollHeight;
  }
  function prompts(){
    const relevant=API.getFaqs().filter(x=>x.enabled&&x.roles.includes(role)).slice(0,4);
    suggestions.replaceChildren();
    for(const faq of relevant){
      const b=document.createElement('button');b.type='button';b.textContent=faq.question;
      b.addEventListener('click',()=>send(faq.question));suggestions.appendChild(b);
    }
  }
  function reset(){
    sessionId='session-'+Date.now().toString(36)+'-'+Math.random().toString(36).slice(2,4);
    messages.replaceChildren();
    append('assistant','Assalam-o-Alaikum! Ask about CareGrid workflows. My responses are admin-managed demo FAQs, not live account data.','CareGrid demo help');
    prompts();
  }
  function send(text) {
    const question=String(text).trim();if(!question)return;
    const limited=question.slice(0,API.getCriteria().maxQuestionLength);
    append('user',API.sanitize(limited));
    const response=API.answer(limited,role);
    append('assistant',response.text,response.source);
    API.storeTurn({role,sessionId,question:limited,response});
    input.value='';
  }
  function open(){
    windowEl.hidden=false;launcher.setAttribute('aria-expanded','true');
    input.focus();messages.scrollTop=messages.scrollHeight;
  }
  function close(){windowEl.hidden=true;launcher.setAttribute('aria-expanded','false');launcher.focus();}
  launcher.addEventListener('click',()=>windowEl.hidden?open():close());
  box.querySelector('.cg-chat-close').addEventListener('click',close);
  box.querySelector('.cg-chat-reset').addEventListener('click',reset);
  form.addEventListener('submit',e=>{e.preventDefault();send(input.value);});
  window.addEventListener('storage',e=>{if(e.key===KEYS.faqs)prompts();});
  reset();
  if(document.body.dataset.caregridFullChat==='true'){
    document.body.classList.add('cg-full-assistant-page');
    launcher.hidden=true;open();
  }
})();
