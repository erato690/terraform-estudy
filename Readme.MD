## Idempotência
Garante que a cada alteração não seja criado novamente toda sua  infraestrutura.
Ele garante  esse funcionamento atravez do gerenciamento de estado.

### Estado
O teraform não cosegue criar nada que ele não conheça o estado anterior, quando acontece isso
ele vai entender que precisa criar tudo do 0.
Então ele precisa conheçer o estado para entender o que ele precisa fazer.

Com o comando  abaixo é possivel rodar o plano onde ele verifica o atual estado
e mostra os itens que vai ser alterado.

```sh
terraform plan
```

para rodar esse plano usando o comando

```sh
terraform apply
```

O arquivo *.tfstate é  onde guarda as informações do estado.

Para deletar um recurso utilizando o terraform utilizamos o comando.

```sh
terraform destroy
```

## Variaveis

### input

Pode comprar as variaveis de input como uma variavel de argumento de uma função.
Elas serve para 

Quando você declara variáveis no módulo raiz de sua configuração, você pode defina seus valores usando opções de CLI e variáveis de ambiente.

```hcl
TF_VAR_NOME_VARIAVEL
```

É possivel passar tambem pelo comando apply seguindo o exemplo:

``` sh
terraform apply -var "nome_variavel=valor"
```
É possivel passar um arquivo de variavel com o comando abaixo:

```sh
terraform apply -var-file "nome_do_arquivo.tfvars"
```
[Referencia](https://developer.hashicorp.com/terraform/language/values/variables)

### Output
são como valores de retorno de função.
Os valores de saída disponibilizam informações sobre sua infraestrutura no linha de comando e pode expor informações para outras configurações do Terraform a usar. Os valores de saída são semelhantes aos valores de retorno nas linguagens de programação.

É possivel verificar o output pela linha de comando:
```sh
terraform output -json
```
[Referencia](https://developer.hashicorp.com/terraform/language/values/outputs)


### Local values
No Terraform, "local values" (ou simplesmente "locals") são uma forma de definir valores que podem ser reutilizados dentro de um módulo Terraform. Eles servem para reduzir a repetição e aumentar a clareza na configuração.

Os valores locais são definidos no bloco locals, e uma vez definidos, podem ser referenciados em qualquer lugar dentro do módulo. Eles são muito úteis para simplificar configurações complexas, armazenar valores fixos ou calculados, e tornar as configurações mais legíveis e gerenciáveis.

exemplo:

```sh
locals {
  prefixo_comum = "meu-projeto"
}

resource "aws_instance" "exemplo" {
  tags = {
    Nome = "${local.prefixo_comum}-instancia"
  }
}
```

Vantagens:
DRY (Don't Repeat Yourself): Você pode definir um valor uma vez como um local e reutilizá-lo em vários lugares, evitando repetição.

Claridade: Locals podem tornar seu código mais claro, pois permitem que você dê nomes descritivos a valores complexos ou repetitivos.

Simplificação de Expressões: Em casos onde você tem uma expressão complexa que é usada várias vezes, você pode simplificar o código movendo a expressão para um local.

Gestão de Configurações Dinâmicas: Útil para lidar com configurações que podem variar com base em certas condições, sem a necessidade de criar múltiplos recursos ou módulos.

[Referencia](https://developer.hashicorp.com/terraform/language/values/outputs)

### MAPA
Um mapa é uma coleção de pares chave-valor onde todas as chaves são do mesmo tipo e todos os valores são do mesmo tipo.
É semelhante a dicionários ou hashmaps em outras linguagens de programação.
No Terraform, um mapa é declarado com a sintaxe map(<TYPE>), onde <TYPE> é o tipo de todos os valores no mapa. As chaves são sempre strings.
Exemplo: map(string) define um mapa onde todas as chaves são strings e todos os valores são strings.

```sh
variable "user_ages" {
  type = map(number)
  default = {
    "Alice" = 30
    "Bob"   = 25
  }
}

```

### Objeto
Um objeto é uma coleção de atributos nomeados, onde cada atributo pode ter um tipo diferente.
É semelhante a estruturas ou registros em outras linguagens de programação.
No Terraform, um objeto é declarado com a sintaxe object({<ATTRIBUTES>}), onde <ATTRIBUTES> define o nome e o tipo de cada atributo.
Exemplo: object({ name = string, age = number }) define um objeto com um atributo name que é uma string e um atributo age que é um número.

exemplo:
```sh
variable "user" {
  type = object({
    name = string
    age  = number
  })
  default = {
    name = "Alice"
    age  = 30
  }
}
```


## Gerenciamento de estado

## Import
No Terraform, o comando import é usado para trazer recursos que já existem (e foram criados fora do Terraform) para o controle do estado do Terraform. O erro ao executar terraform plan antes do terraform import geralmente ocorre devido a uma discrepância entre o estado atual dos recursos na infraestrutura e o que o Terraform espera encontrar com base em sua configuração.
Quando você executa terraform plan, o Terraform compara o estado atual dos recursos (como armazenado no arquivo de estado do Terraform) com o que está definido nos arquivos de configuração. Se você ainda não importou os recursos existentes para o estado do Terraform, o Terraform não tem conhecimento deles e, portanto, pode relatar que os recursos precisam ser criados.
Portanto, é importante executar terraform import antes de terraform plan para recursos existentes que você deseja gerenciar com o Terraform, garantindo que o estado do Terraform esteja sincronizado com a infraestrutura real.
Basta declara um resource com o  item que esta fazendo o import  e rodar comando abaixo:

```sh
terraform import resource.name  name-item-in-aws
```
Exemplo:
Na pasta s3-import estou fazendo um import de um S3.
```sh
terraform import aws_s3_bucket.s3_import s3-import-terraform
```

## Remote state
O "remote state" no Terraform é uma funcionalidade que permite armazenar o estado da sua infraestrutura em um local remoto, em vez de localmente em seu sistema. O estado do Terraform é um arquivo que registra o status atual de todos os recursos gerenciados pelo Terraform em um projeto. Esse arquivo é crucial para que o Terraform possa gerenciar e atualizar recursos de forma eficaz.

Usar um estado remoto é considerado uma prática recomendada para gerenciamento de infraestrutura como código, especialmente em ambientes de equipe ou em escala empresarial.
Para ele realizar o lock é preciso criar uma tabela no dynamo.

Exemplo:
Primeiro, crie um bucket S3 e uma tabela DynamoDB na AWS:

Bucket S3: Por exemplo, meu-bucket-terraform.
Tabela DynamoDB: Por exemplo, meu-lock-terraform.

Configurando o backend no Terraform:
No seu arquivo Terraform (por exemplo, main.tf), você configuraria o backend da seguinte maneira:

```sh
terraform {
  backend "s3" {
    bucket         = "meu-bucket-terraform"
    key            = "path/to/my/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "meu-lock-terraform"
    encrypt        = true
  }
}
```
Neste exemplo, o estado do Terraform será armazenado no bucket S3 especificado, e a tabela DynamoDB será usada para o locking de estado.

Interagindo com o Estado Remoto pela Linha de Comando
Depois de configurar o seu estado remoto, você pode interagir com ele usando comandos do Terraform na linha de comando. Aqui estão alguns exemplos básicos:

Inicializar o Terraform.

Aplicar a Configuração do Terraform.

Tambem é possivel passar as configurações do backend pela linha de comando e um arquivo de chave/valor .hcl,

Quando você executa terraform init com a opção -backend=true, o Terraform irá inicializar o backend com base nas configurações especificadas no seu arquivo Terraform. Isso inclui a configuração do estado remoto, se especificado. Aqui está como você pode usá-lo:

```sh
terraform init -backend=true
```

criar um arquivo hcl como na pasta remote-state.

Dentro do provider.ts precisa ter o trecho de codigo, backend como no exemplo abaixo:
```
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
  }
}
```

Esse comando é especialmente útil nas seguintes situações:

Mudança de Configuração: Se você modificar a configuração do backend em seu arquivo Terraform (por exemplo, mudando o bucket do S3 ou a região), você precisará reexecutar terraform init com a flag -backend=true para aplicar essas alterações.

Primeira Inicialização: Ao iniciar um novo projeto com um backend remoto configurado, você usará esse comando para configurar o Terraform para usar o backend especificado.

Migrar Estado: Se você está migrando de um estado local para um remoto (ou vice-versa), ou de um tipo de backend remoto para outro, você usará esse comando para reconfigurar o backend e mover o estado.

## Data Sources
A data solicitações de bloco que o Terraform leia de uma determinada fonte de dados ("aws_ami") e exportar o resultado sob o nome local dado ("exemplo"). O nome é usado para se referir a este recurso de outras partes do mesmo módulo Terraform, mas tem nenhum significado fora do escopo de um módulo.

O Terraform lê os recursos de dados durante a fase de planejamento, quando possível, mas anuncia no plano quando deve adiar os recursos de leitura até a aplicação fase para preservar a ordem das operações. Terraform adia leitura de dados recursos nas seguintes situações:

- Pelo menos um dos argumentos fornecidos é um atributo de recurso gerenciado ou outro valor que o Terraform não pode prever até a etapa de aplicação.
- O recurso de dados depende diretamente de um recurso gerenciado que ele mesmo possui mudanças planejadas no plano atual.
- O recurso de dados tem condições personalizadas e depende direta ou indiretamente de um recurso gerenciado que ele próprio mudanças planejadas no plano atual.

Enquanto muitas fontes de dados correspondem a um tipo de objeto de infraestrutura que é acessado através de uma API de rede remota, algumas fontes de dados especializadas operam somente dentro da própria Terraform, calculando alguns resultados e expondo-os para uso em outro lugar.

Por exemplo, existem fontes de dados somente locais para [template-file](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file?product_intent=terraform), [local_file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file?product_intent=terraform), e [iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document?product_intent=terraform).

O comportamento de fontes de dados somente locais é o mesmo de todos os outros dados fontes, mas seus dados de resultados existem apenas temporariamente durante um Terraform operação, e é recalculado cada vez que um novo plano é criado.

Cada resource pode ter um data source especifico como:

- [S3_data_source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) 
- [EC2_AMI](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami)

[Referencia](https://developer.hashicorp.com/terraform/language/data-sources)

### Validações


## Meta Arguments

### for-each

No Terraform, a estrutura for_each é utilizada para criar múltiplas instâncias de um recurso ou módulo a partir de uma coleção de entrada, como um mapa ou um conjunto. Isso é particularmente útil quando você deseja criar recursos semelhantes com apenas pequenas variações entre eles.

Aqui está um resumo de como o for_each funciona:

Definindo a Coleção de Entrada
Você define um mapa ou um conjunto de valores que o for_each usará. Cada elemento desta coleção será usado para criar uma instância do recurso ou módulo.

Aplicando o for_each a um Recurso ou Módulo: No recurso ou módulo que você deseja replicar, você utiliza a palavra-chave for_each seguida pela coleção de entrada.

Acessando o Valor Atual
Dentro do bloco do recurso ou módulo, você pode acessar o valor atual sendo processado por meio da variável each. each.key refere-se à chave atual (no caso de um mapa) e each.value refere-se ao valor atual (tanto para mapas quanto para conjuntos).

Criação de Recursos Únicos
O Terraform cria uma instância única do recurso ou módulo para cada elemento da coleção de entrada. O identificador de cada recurso será composto pelo nome do recurso e pela chave do elemento (no caso de mapas) ou pelo valor do elemento (no caso de conjuntos).

como no exemplo abaixo:

definindo multiplos providers:

```sh
provider "aws" {
  alias  = "east"
  region = "us-east-1"
}

provider "aws" {
  alias  = "west"
  region = "us-west-1"
}
```
criando a variavel instances:

```sh
variable "instances" {
  type = map(object({
    region        = string
    instance_type = string
  }))
  default = {
    instance1 = {
      region        = "us-east-1"
      instance_type = "t2.micro"
    },
    instance2 = {
      region        = "us-west-1"
      instance_type = "t2.small"
    }
  }
}
```

Utilize a chave do provider correto ao criar cada instância:
```sh
resource "aws_instance" "example" {
  for_each = var.instances

  provider      = aws[each.value.region == "us-east-1" ? "east" : "west"]
  ami           = "ami-0c55b159cbfafe1f0"  # Substitua por um AMI válido para a região
  instance_type = each.value.instance_type
  tags = {
    Name = "Instance-${each.key}"
  }
}
```

### FOR

A expressão for é uma construção do Terraform que permite transformar uma lista ou um mapa em outro formato. Ela é frequentemente usada em outputs, locals, ou dentro de recursos para manipular dados.

Exemplo de uma expressão for transformando uma lista:
```sh
locals {
  original_list = [1, 2, 3, 4, 5]
  multiplied_list = [for num in local.original_list: num * 2]
}
```
o resultado sera:

```sh
local.multiplied_list= [2, 4, 6, 8, 10]
```

Transformando um Mapa
Se você tiver um mapa de nomes e idades e quiser criar um novo mapa onde as idades são aumentadas em 1 ano:

```sh
locals {
  original_map = {
    "Alice" = 30
    "Bob"   = 25
  }
  updated_map = {for name, age in local.original_map: name => age + 1}
}
```

o resultado sera:
```sh
local.updated_map = {"Alice" = 31, "Bob" = 26}
```

## Modules


Os módulos no Terraform são usados para organizar e reutilizar código. Eles funcionam como contêineres de recursos do Terraform, onde um conjunto de recursos e configurações pode ser agrupado e reutilizado em diferentes partes do seu código do Terraform. Aqui está uma visão geral de como eles funcionam:

Organização de Código: Módulos ajudam a organizar o código do Terraform em blocos lógicos, facilitando a manutenção e a compreensão. Por exemplo, você pode ter um módulo para redes, outro para instâncias de VM, etc.

Reutilização: Uma vez criado, um módulo pode ser reutilizado em diferentes projetos ou partes do mesmo projeto, o que economiza tempo e evita a repetição de código.

Estrutura de um Módulo: Um módulo é simplesmente um diretório contendo arquivos .tf. Este diretório pode ser local (no mesmo sistema de arquivos que o seu projeto Terraform) ou remoto (como um repositório Git).

Chamada de Módulo: Para usar um módulo, você o "chama" em seu código Terraform principal usando um bloco module. Você especifica o caminho do módulo e passa as variáveis necessárias.

Exemplo:

```hcl
module "nome_do_modulo" {
  source = "caminho/para/o/modulo"
  variavel1 = "valor1"
  variavel2 = "valor2"
}

```

## Dynamic block


