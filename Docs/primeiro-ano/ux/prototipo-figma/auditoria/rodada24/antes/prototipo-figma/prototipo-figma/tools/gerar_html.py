"""Projeção estática dos JSPs para revisão. Não é backend e não recebe/grava cadastros."""
from pathlib import Path
import html
import json
import re
from urllib.parse import parse_qs, urlsplit, urlencode

ROOT = Path(__file__).resolve().parents[1]
ROUTES = {'/': 'home', '/home': 'home', '/sobre-nos': 'sobre-nos', '/planos': 'planos', '/faq': 'faq',
          '/login': 'home', '/logout': 'home', '/inicio': 'home-crud-page', '/empresas': 'companies',
          '/lojas': 'stores', '/funcionarios': 'employees', '/cargos': 'employee-roles',
          '/contas': 'user-accounts', '/planos-administrativos': 'subscription-plans', '/enderecos': 'addresses', '/administrations': 'administrations'}
PREFIX = {'companies': 'empresa', 'stores': 'loja', 'employees': 'funcionario', 'employee-roles': 'cargo',
          'user-accounts': 'conta', 'subscription-plans': 'plano', 'addresses': 'endereco', 'administrations': 'administration'}
PAGE_GROUPS = {'companies':'empresas','stores':'lojas','employees':'funcionarios','employee-roles':'cargos',
               'user-accounts':'contas','subscription-plans':'planos','addresses':'enderecos',
               'administrations':'administrations','home-crud-page':'cadastrosRecentes'}
PAGE_IDS = {'companies':'companyId','stores':'storeId','employees':'employeeId','employee-roles':'roleId',
            'user-accounts':'userId','subscription-plans':'planId','addresses':'addressId','administrations':'administrationId'}



class Obj(dict):
    def __getattr__(self, key):
        return self.get(key, '')

    def __bool__(self):
        return self.get('_visible', len(self) > 0)


def obj(value):
    if isinstance(value, dict):
        return Obj({key: obj(val) for key, val in value.items()})
    if isinstance(value, list):
        return [obj(val) for val in value]
    return value


def data():
    # Valores fixos usados somente na geração de HTML; sem API, persistência ou estados JS.
    names = ['Mercado Aurora', 'Hortifruti do Vale', 'Rede Verde', 'Bom Preço', 'Mercado Sul', 'Mercado Central']
    people = ['Ana Souza', 'Bruno Lima', 'Carla Santos', 'Diego Rocha', 'Elisa Costa', 'Felipe Alves']
    roles = ['Gerente de loja', 'Estoquista', 'Operador de loja', 'Supervisor', 'Analista', 'Assistente']
    stores = ['Aurora • Centro', 'Aurora • Osasco', 'Vale • Jardim', 'Verde • Norte', 'Sul • Centro', 'Central • Cambuí']
    entities = {key: [] for key in ['empresas', 'lojas', 'funcionarios', 'cargos', 'contas', 'planos', 'enderecos']}
    streets = ['Praça da Sé', 'Rua Primitiva Vianco', 'Rua das Palmeiras', 'Avenida Rio Branco', 'Rua dos Andradas', 'Rua Maria Monteiro']
    cities = ['São Paulo', 'Osasco', 'São José dos Campos', 'Rio de Janeiro', 'Porto Alegre', 'Campinas']
    for i in range(6):
        common = dict(active=i != 3, createdAt='2026-09-01', updatedAt='2026-10-05', deletedAt=None,
                      createdAtFormatted='01/09/2026', updatedAtFormatted='05/10/2026', deletedAtFormatted='—')
        entities['empresas'].append(dict(common, companyId=i+1, tradeName=names[i], officialName=names[i]+' Alimentos Ltda.',
            cnpj='12.345.678/0001-'+str(90+i), email='contato'+str(i+1)+'@mercado.example', phone='(11) 3333-100'+str(i),
            subscriptionPlanId=1, subscriptionPlanName='Start', latitude='-23.550520', longitude='-46.633308'))
        entities['lojas'].append(dict(common, storeId=i+1, name=stores[i], companyName=names[i], companyId=i+1, addressId=i+1,
            cnpj='12.345.678/0002-'+str(70+i), email='loja'+str(i+1)+'@mercado.example', phone='(11) 3333-200'+str(i),
            addressStreet=streets[i], addressNumber=str(100+i*50), addressCity=cities[i], latitude='-23.55', longitude='-46.63'))
        entities['funcionarios'].append(dict(common, employeeId=i+1, name=people[i], storeId=i+1, storeName=stores[i], roleId=i+1,
            roleName=roles[i], cpf='529.982.247-25', email=people[i].split()[0].lower()+'@mercado.example', phone='(11) 90000-100'+str(i), hireDate='2026-09-01', hireDateFormatted='01/09/2026'))
        entities['cargos'].append(dict(common, roleId=i+1, name=roles[i], description=['Gerencia a equipe e a operação da loja.',
            'Consulta e atualiza o estoque.', 'Registra movimentações da loja.', 'Acompanha a operação das lojas.',
            'Consulta indicadores e relatórios.', 'Apoia as rotinas de cadastro.'][i], permissionLevel=[3,1,1,3,2,1][i], employeeCount=6))
        entities['contas'].append(dict(common, userId=i+1, employeeId=i+1, employeeName=people[i], email=people[i].split()[0].lower()+'@mercado.example',
            storeName=stores[i], roleName=roles[i], lastLogin='2026-10-08', lastLoginFormatted='08/10/2026 08:40'))
        entities['planos'].append(dict(common, planId=i+1, name=['Start','Growth','Scale'][i % 3], description='Plano de demonstração para avaliação visual.',
            price=[399,1049,1849][i % 3], storeLimit=[1,3,5][i % 3], userLimit=[6,18,30][i % 3], companyCount=i+1))
        entities['enderecos'].append(dict(common, addressId=i+1, zipCode=['01001-000','06010-000','12210-000','20040-020','90010-150','13024-050'][i],
            street=streets[i], number=str(100+i*50), neighborhood=['Sé','Centro','Jardim Paulista','Centro','Centro Histórico','Cambuí'][i], city=cities[i], state=['SP','SP','SP','RJ','RS','SP'][i], complement='', storeName=stores[i]))
    model = dict(entities, pageContext={'request': {'contextPath': ''}}, param={'acao':'','busca':'','situacao':''},
                 paginaAtual=1, totalPaginas=3, totalRegistros=18, inicioLista=1, fimLista=6, mensagem='', erro='', fieldErrors={}, abrirLogin=False)
    for group, prefix in [('empresas','empresa'),('lojas','loja'),('funcionarios','funcionario'),('cargos','cargo'),('contas','conta'),('planos','plano'),('enderecos','endereco')]:
        model[prefix+'Criar'] = {'_visible': False}
        for mode in ['Editar','Ver','Excluir']:
            model[prefix+mode] = dict(entities[group][0], _visible=False)
    for key, group in [('planosDisponiveis','planos'),('empresasDisponiveis','empresas'),('lojasDisponiveis','lojas'),
                       ('enderecosDisponiveis','enderecos'),('cargosDisponiveis','cargos'),('funcionariosDisponiveis','funcionarios')]:
        model[key] = entities[group]
    for name in ['Empresas','Lojas','Funcionarios','Contas']:
        model['total'+name]=6; model['total'+name+'Ativas' if name!='Funcionarios' else 'totalFuncionariosAtivos']=5
        model['total'+name+'Inativas' if name!='Funcionarios' else 'totalFuncionariosInativos']=1
    model['cadastrosRecentes']=[dict(nome=people[i], tipo='Conta de usuário' if i%2==0 else 'Cargo', dataFormatada='07/10/2026', ativo=True) for i in range(6)]
    model.update(sessionScope={'administrationId':7,'administrationEmail':'admin.preview@example.test'}, administrations=[{'administrationId':7+i,'email':('admin.preview@example.test' if i==0 else 'admin.'+str(7+i)+'@example.test')} for i in range(6)], administrationForm={}, administration={'administrationId':7,'email':'admin.preview@example.test'}, administrationFormOpen=False, administrationView=False, isEdit=False, administrationId=7)
    return obj(model)


def empty(value):
    return not bool(value)


def evaluate(expression, model):
    expression = expression.strip()
    if expression.startswith('${') and expression.endswith('}'):
        expression = expression[2:-1].strip()
    # As expressões vêm somente dos JSPs locais confiáveis; nenhum input HTTP é avaliado.
    expression = re.sub(r'\s+', ' ', expression)
    if '?' in expression:
        condition, rest = expression.split('?', 1)
        yes, no = rest.split(':', 1)
        return evaluate(yes if evaluate(condition, model) else no, model)
    expression = re.sub(r'\bfn:length\(', 'len(', expression)
    expression = re.sub(r'\bempty\s+([\w.]+)', r'empty(\1)', expression)
    expression = expression.replace('&&',' and ').replace('||',' or ')
    expression = re.sub(r'!(?!=)', ' not ', expression)
    expression = re.sub(r'\btrue\b','True',expression)
    expression = re.sub(r'\bfalse\b','False',expression)
    expression = re.sub(r'\bnull\b','None',expression)
    for old, new in [('eq','=='),('ne','!='),('gt','>'),('lt','<'),('ge','>='),('le','<=')]:
        expression = re.sub(r'\b'+old+r'\b',new,expression)
    try:
        return eval(expression.strip(), {'__builtins__': {}, 'empty':empty, 'len':len}, model)
    except (NameError,AttributeError,TypeError,KeyError,SyntaxError,ValueError):
        return ''


ATTR = re.compile(r'([\w:-]+)\s*=\s*(?:"([^"]*)"|\x27([^\x27]*)\x27)')
TAG = re.compile(r'</?(?:c|fmt):[\w]+\b(?:"[^"]*"|\x27[^\x27]*\x27|[^\x27">])*?>', re.S)


def attrs(tag):
    return {m.group(1): m.group(2) if m.group(2) is not None else m.group(3) for m in ATTR.finditer(tag)}


def parse(text, start=0, closing=None):
    nodes = []
    while True:
        match = TAG.search(text, start)
        if not match:
            nodes.append(text[start:]); return nodes, len(text)
        nodes.append(text[start:match.start()])
        raw = match.group(); name = re.search(r'(?:c|fmt):([\w]+)',raw).group(1)
        if raw.startswith('</'):
            if name != closing:
                raise ValueError('Fechamento JSTL inesperado: '+raw)
            return nodes, match.end()
        at = attrs(raw)
        if raw.endswith('/>') or name in ('out','formatNumber'):
            nodes.append((name,at,[])); start = match.end()
        else:
            children, start = parse(text, match.end(), name)
            nodes.append((name,at,children))


def interpolate(text, model):
    def replace(m):
        value = evaluate(m.group(1),model)
        if value is None: return ''
        if isinstance(value,bool): return 'true' if value else 'false'
        return html.escape(str(value),quote=True)
    return re.sub(r'\$\{([^}]+)\}', replace, text)


def render(nodes, model):
    out = []
    for node in nodes:
        if isinstance(node,str): out.append(interpolate(node,model)); continue
        kind, at, children = node
        if kind == 'out':
            value = evaluate(at.get('value',''),model)
            out.append(html.escape(str(value) if value is not None else '',quote=True))
        elif kind == 'url':
            url = html.unescape(interpolate(at.get('value', ''), model))
            params = [(child[1]['name'], html.unescape(interpolate(child[1].get('value', ''), model)))
                      for child in children if isinstance(child, tuple) and child[0] == 'param']
            if params: url += ('&' if '?' in url else '?') + urlencode(params)
            if 'var' in at: model[at['var']] = url
            else: out.append(html.escape(url, quote=True))
        elif kind == 'formatNumber':
            value = evaluate(at.get('value','0'),model)
            try: out.append(f'{float(value):,.2f}'.replace(',','X').replace('.',',').replace('X','.'))
            except (ValueError,TypeError): out.append('0,00')
        elif kind in ('if','when'):
            if evaluate(at.get('test','false'),model): out.append(render(children,model))
        elif kind == 'otherwise': out.append(render(children,model))
        elif kind == 'choose':
            for child in children:
                if isinstance(child,tuple) and (child[0]=='otherwise' or child[0]=='when' and evaluate(child[1].get('test','false'),model)):
                    out.append(render(child[2],model)); break
        elif kind == 'forEach':
            if 'items' in at: values=evaluate(at['items'],model) or []
            else: values=range(int(evaluate(at.get('begin','0'),model)),int(evaluate(at.get('end','0'),model))+1)
            for i,value in enumerate(values):
                local=Obj(model); local[at.get('var','item')]=value
                if 'varStatus' in at: local[at['varStatus']]=Obj(index=i,count=i+1,first=i==0)
                out.append(render(children,local))
        else: raise ValueError('Tag não suportada no preview: '+kind)
    return ''.join(out)


def local_link(url, page):
    url=html.unescape(url)
    if '/prototipo-figma/' in url: return '../'+url.split('/prototipo-figma/',1)[1]
    if url.startswith(('#','http:','https:','mailto:','tel:','data:')): return url
    if url=='faq.jsp': return 'faq.html'
    bits=urlsplit(url)
    if bits.path == '/administrations/new': return 'administrations.html#modal-administration-criar'
    if re.fullmatch(r'/administrations/\d+/edit',bits.path): return 'administrations.html#modal-administration-editar'
    if re.fullmatch(r'/administrations/\d+',bits.path): return 'administrations.html#modal-administration-ver'
    target=ROUTES.get(bits.path)
    if not target: return url
    query=parse_qs(bits.query)
    if target in PREFIX and query.get('acao',[''])[0] in ['criar','editar','ver','excluir']:
        return target+'.html#modal-'+PREFIX[target]+'-'+query['acao'][0]
    if target in PAGE_GROUPS and 'pagina' in query:
        page = max(1, min(int(query['pagina'][0]), 3))
        target += '-pagina-'+str(page) if page > 1 else ''
    return target+'.html'+('?' + bits.query if bits.query else '')+('#'+bits.fragment if bits.fragment else '')


def generate(name, login=False, many_records=0, administration_edit=False, preview_page=1):
    text=(ROOT/'jsp'/name).read_text(encoding='utf-8')
    text=re.sub(r'<%[\s\S]*?%>','',text)
    model=data(); model['abrirLogin']=login
    stem=Path(name).stem
    if stem in PAGE_GROUPS:
        # Apenas páginas HTML estáticas de demonstração; o JSP continua sendo a referência funcional.
        page=max(1,min(preview_page,3)); model['paginaAtual']=page
        model['inicioLista']=(page-1)*6+1; model['fimLista']=page*6
        if page>1:
            rows=[]
            for original in model[PAGE_GROUPS[stem]]:
                row=Obj(original)
                if stem in PAGE_IDS: row[PAGE_IDS[stem]] += (page-1)*6
                for field in ['tradeName','officialName','name','employeeName','street','nome']:
                    if field in row: row[field] += ' · '+str(page)
                if 'email' in row: row['email']=row['email'].replace('@','+'+str(page)+'@',1)
                rows.append(row)
            model[PAGE_GROUPS[stem]]=rows
    if administration_edit:
        model.update(isEdit=True, administrationForm=obj({'email':'admin.preview@example.test'}))
    if many_records and name=='companies.jsp':
        originals=model['empresas']
        model['empresas']=[Obj(dict(originals[i % len(originals)],companyId=i+1,
            tradeName=originals[i % len(originals)].tradeName+' · preview '+str(i+1))) for i in range(many_records)]
        model.update(totalRegistros=many_records,fimLista=many_records)
    text=render(parse(text)[0],model)
    text=re.sub(r'\b(src|href|action)="([^"]*)"',lambda m:m.group(1)+'="'+html.escape(local_link(m.group(2),name),quote=True)+'"',text)
    # Só o HTML visual é neutralizado. Os forms dos JSPs continuam intactos.
    def form(m):
        tag=m.group();tag=re.sub(r'\s+method="[^"]*"','',tag)
        tag=re.sub(r'\s+action="[^"]*"','',tag)
        return tag[:-1]+' method="dialog"'+'>'
    text=re.sub(r'<form\b[^>]*>',form,text)
    text=re.sub(r'\s+onclick="[^"]*"','',text)
    text=text.replace('<body','<body data-preview="static"',1)
    if '${' in text or re.search(r'<(?:c|fmt):',text): raise ValueError('JSP residual em '+name)
    if name == 'administrations.jsp' and not administration_edit:
        # Estado estático de edição deriva do mesmo formulário JSP, sem simular gravação.
        edit = generate(name, administration_edit=True, preview_page=preview_page)
        modal = edit[edit.index('<div id="modal-administration-criar"'):edit.index('<div id="modal-administration-ver"')]
        modal = modal.replace('id="modal-administration-criar"', 'id="modal-administration-editar"', 1)
        modal = modal.replace('administration-email', 'administration-edit-email').replace('administration-password', 'administration-edit-password')
        text = text.replace('</body>', modal + '</body>')
    return text


def main():
    results=[]
    for page in sorted((ROOT/'jsp').glob('*.jsp')):
        output=generate(page.name)
        (ROOT/'html'/(page.stem+'.html')).write_text(output,encoding='utf-8')
        results.append({'jsp':page.name,'html':page.stem+'.html','bytes':len(output.encode('utf-8'))})
    for stem in PAGE_GROUPS:
        for page in [2,3]:
            filename=stem+'-pagina-'+str(page)+'.html'
            (ROOT/'html'/filename).write_text(generate(stem+'.jsp',preview_page=page),encoding='utf-8')
            results.append({'jsp':stem+'.jsp','html':filename,'previewPage':page})
    (ROOT/'auditoria/html-gerados.json').write_text(json.dumps(results,indent=2),encoding='utf-8')
    long_page=generate('companies.jsp',many_records=60)
    long_page=long_page.replace('../css/','../../css/').replace('../js/','../../js/').replace('../assets/','../../assets/')
    long_page=re.sub(r'href="([a-z-]+\.html)',r'href="../../html/\1',long_page)
    (ROOT/'auditoria/rodada2/muitos-registros.html').write_text(long_page,encoding='utf-8')
    print('Gerados',len(results),'HTMLs a partir dos JSPs do protótipo.')


if __name__=='__main__': main()
