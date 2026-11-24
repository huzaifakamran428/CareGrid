(() => {
  'use strict';
  const api=window.CareGridDemoChat;
  if (!api) return;
  const $=id=>document.getElementById(id);
  const mode=$('server-mode');
  const unlock=$('server-unlock');
  const keyInput=$('server-key');
  const protectedAreas=[document.querySelector('.cg-control-grid'),
    document.querySelector('.cg-control-main > .cg-control-panel')];
  const dialog=$('faq-dialog'),form=$('faq-form');
  let serverMode=false,adminKey='',snapshot=null;
  const notice=text=>{
    const el=$('admin-notice');el.textContent=text;
    clearTimeout(notice.t);notice.t=setTimeout(()=>el.textContent='',3500);
  };
  const lockUI=locked=>protectedAreas.forEach(el=>{if(el)el.hidden=locked;});
  const faqs=()=>serverMode?(snapshot?.faqs||[]):api.getFaqs();
  const criteria=()=>serverMode?(snapshot?.criteria||api.getCriteria()):api.getCriteria();
  const history=()=>serverMode?(snapshot?.history||[]):api.getHistory();
  function authHeaders(){
    return {'Content-Type':'application/json','X-CareGrid-Admin-Key':adminKey};
  }
  async function request(path,method='GET',payload) {
    const response=await fetch(path,{
      method,credentials:'same-origin',cache:'no-store',
      headers:authHeaders(),body:payload===undefined?undefined:JSON.stringify(payload)
    });
    let data={};
    try { data=await response.json(); } catch (_) { /* error below */ }
    if (!response.ok) throw new Error(data.error||('Request failed with '+response.status));
    return data;
  }
  async function refresh(){
    if (!serverMode||!adminKey) return;
    snapshot=await request('/api/assistant/admin/state');
    renderAll();
  }
  async function saveFaqs(items){
    if (!serverMode) {
      if (!api.setFaqs(items)) throw new Error('Browser storage unavailable');
      renderAll();return;
    }
    const data=await request('/api/assistant/admin/faqs','PUT',{faqs:items});
    snapshot.faqs=data.faqs;
    renderAll();
  }
  async function saveCriteria(data){
    if (!serverMode) {
      if (!api.setCriteria(data)) throw new Error('Browser storage unavailable');
    } else {
      const result=await request('/api/assistant/admin/criteria','PUT',{criteria:data});
      snapshot.criteria=result.criteria;
    }
    fillCriteria();renderAll();
  }
  async function clear(){
    if (!serverMode) api.clearHistory();
    else {
      await request('/api/assistant/admin/history','DELETE');
      snapshot.history=[];
    }
    renderAll();
  }
  function count(){
    $('faq-count').textContent=faqs().filter(x=>x.enabled).length;
    $('chat-count').textContent=history().length;
  }
  function renderFaqs(){
    const container=$('faq-list');container.replaceChildren();
    for (const faq of faqs()){
      const row=document.createElement('article');row.className='cg-faq-row'+(faq.enabled?'':' off');
      const info=document.createElement('div');
      const title=document.createElement('h3');title.textContent=faq.question;
      const para=document.createElement('p');para.textContent=faq.answer;
      const meta=document.createElement('small');
      meta.textContent=faq.category+' · '+faq.roles.map(x=>api.ROLE_LABELS[x]).join(', ')+' · '+(faq.enabled?'Enabled':'Disabled');
      info.append(title,para,meta);
      const actions=document.createElement('div');actions.className='cg-faq-actions';
      const edit=document.createElement('button');edit.type='button';edit.textContent='Edit';
      edit.addEventListener('click',()=>openForm(faq));
      const toggle=document.createElement('button');toggle.type='button';toggle.textContent=faq.enabled?'Disable':'Enable';
      toggle.addEventListener('click',async ()=>{
        const items=faqs().map(x=>({...x}));
        const item=items.find(x=>x.id===faq.id);
        if(item)try{item.enabled=!item.enabled;await saveFaqs(items);notice('Demo question updated.');}
        catch(e){notice(e.message);}
      });
      const del=document.createElement('button');del.type='button';del.textContent='Delete';
      del.addEventListener('click',async ()=>{
        if(confirm('Delete this demo FAQ?'))try{
          await saveFaqs(faqs().filter(x=>x.id!==faq.id));notice('Question deleted.');
        }catch(e){notice(e.message);}
      });
      actions.append(edit,toggle,del);row.append(info,actions);container.appendChild(row);
    }
    if (!container.children.length) {
      const p=document.createElement('p');p.textContent='No FAQs. Add a question to start.';
      container.appendChild(p);
    }
  }
  function openForm(faq){
    form.reset();
    $('dialog-heading').textContent=faq?'Edit approved question':'Add approved question';
    form.elements.id.value=faq?.id||'';
    for(const field of ['question','answer','keywords','category'])
      form.elements[field].value=faq?.[field]||(field==='category'?'General':'');
    form.elements.enabled.checked=faq?.enabled!==false;
    form.querySelectorAll('input[name="roles"]').forEach(input=>
      input.checked=faq?faq.roles.includes(input.value):true);
    dialog.showModal();form.elements.question.focus();
  }
  form.addEventListener('submit',async e=>{
    e.preventDefault();
    const fd=new FormData(form),roles=fd.getAll('roles').map(String);
    if(!roles.length){notice('Select at least one role.');return;}
    const faq={
      id:String(fd.get('id')||'faq-'+Date.now()+'-'+Math.random().toString(36).slice(2,5)),
      question:String(fd.get('question')).trim(),answer:String(fd.get('answer')).trim(),
      keywords:String(fd.get('keywords')).trim(),category:String(fd.get('category')).trim(),
      roles,enabled:fd.has('enabled')
    };
    if(!faq.question||!faq.answer||!faq.keywords){
      notice('Question, answer and keywords are required.');return;
    }
    const items=faqs().map(x=>({...x}));
    const index=items.findIndex(x=>x.id===faq.id);
    if(index>=0)items[index]=faq;else items.unshift(faq);
    try{
      await saveFaqs(items);dialog.close();notice('Approved demo question saved.');
    }catch(err){notice(err.message);}
  });
  $('new-faq').addEventListener('click',()=>openForm());
  $('close-faq').addEventListener('click',()=>dialog.close());
  const criteriaForm=$('criteria-form');
  function fillCriteria(){
    const c=criteria();
    for(const k of ['minimumMatches','maxQuestionLength','prohibited','fallback'])
      criteriaForm.elements[k].value=c[k];
    criteriaForm.elements.retainHistory.checked=!!c.retainHistory;
  }
  criteriaForm.addEventListener('submit',async e=>{
    e.preventDefault();
    const f=criteriaForm.elements;
    const next={
      minimumMatches:Number(f.minimumMatches.value),
      maxQuestionLength:Number(f.maxQuestionLength.value),
      prohibited:f.prohibited.value.trim(),
      fallback:f.fallback.value.trim(),retainHistory:f.retainHistory.checked,
    };
    try{await saveCriteria(next);notice('Criteria saved for shared local server.');}
    catch(err){notice(err.message);}
  });
  function renderHistory(){
    const role=$('history-role').value,container=$('history-body');
    container.replaceChildren();
    const logs=history().filter(x=>role==='all'||x.role===role).slice().reverse();
    for(const h of logs){
      const tr=document.createElement('tr');
      const date=document.createElement('td');date.textContent=new Date(h.date).toLocaleString();
      const kind=document.createElement('td');kind.textContent=api.ROLE_LABELS[h.role]||h.role;
      const question=document.createElement('td');question.textContent=h.question;
      const answer=document.createElement('td');answer.textContent=h.answer;
      const source=document.createElement('small');source.textContent=h.source;
      answer.appendChild(source);tr.append(date,kind,question,answer);container.appendChild(tr);
    }
    if(!logs.length){
      const tr=document.createElement('tr'),td=document.createElement('td');
      td.colSpan=4;td.textContent='No demo conversations for the selected role.';
      tr.appendChild(td);container.appendChild(tr);
    }
  }
  $('history-role').addEventListener('change',renderHistory);
  $('clear-history').addEventListener('click',async ()=>{
    if(confirm('Delete the stored demo conversation history?'))try{
      await clear();notice('Demo history deleted.');
    }catch(err){notice(err.message);}
  });
  $('export-history').addEventListener('click',()=>{
    const text=JSON.stringify({
      exportedAt:new Date().toISOString(),
      scope:serverMode?'Local SQLite demo server; roles claimed by preview pages':'One browser profile only',
      history:history(),
    },null,2);
    const blob=new Blob([text],{type:'application/json'}),url=URL.createObjectURL(blob);
    const a=document.createElement('a');a.href=url;a.download='caregrid-demo-chat-history.json';
    a.click();setTimeout(()=>URL.revokeObjectURL(url),1000);
  });
  function renderAll(){renderFaqs();renderHistory();count();}
  unlock.addEventListener('submit',async e=>{
    e.preventDefault();
    const entered=keyInput.value;
    if(entered.length<16){notice('Enter the local demo admin key (16+ characters).');return;}
    adminKey=entered;keyInput.value='';
    try{
      await refresh();
      unlock.hidden=true;lockUI(false);
      mode.textContent='Connected to the localhost SQLite assistant. Key is kept in this page only, until you reload.';
      fillCriteria();notice('Local admin controls unlocked.');
    }catch(err){
      adminKey='';lockUI(true);notice(err.message);
      mode.textContent='Locked: '+err.message;
    }
  });
  $('refresh-server').addEventListener('click',async ()=>{
    try{await refresh();notice('Shared demo settings and history refreshed.');}
    catch(err){notice(err.message);lockUI(true);}
  });
  async function init(){
    lockUI(true);
    try{
      const response=await fetch('/api/assistant/status',{cache:'no-store',credentials:'same-origin'});
      const status=response.ok?await response.json():{};
      serverMode=status.online===true&&status.mode==='local-sqlite-demo';
      if(!serverMode)throw new Error('No localhost API');
      unlock.hidden=false;
      mode.textContent=status.adminKeyConfigured?
        'Shared SQLite demo detected. Enter the local administrator key to edit FAQs and view history.':
        'Shared demo is read-only. Restart the server with CAREGRID_DEMO_ADMIN_KEY set to unlock admin controls.';
      $('refresh-server').hidden=false;
    }catch(_){
      serverMode=false;
      unlock.hidden=true;lockUI(false);
      mode.textContent='No SQLite server detected. Running the older browser-only demo; history is not shared between browsers.';
      fillCriteria();renderAll();
    }
  }
  void init();
})();
