# Cadastro de pedidos e seus itens

## Desafio técnico - WK Technology

## Menu

- [Introdução](#introdução)
  
- [Configurações Iniciais](#configurações)

- [Arquitetura](#arquitetura)

- [Dicas de Uso](#dicas)

- [Padrões Aplicados](#padrões)

- [Boas Práticas](#boas)

  



## Introdução

Este projeto é uma aplicação Delphi, desenvolvida como forma de desafio técnico para o processo seletivo para a vaga de programador Delphi. A aplicação registra pedidos e seus respectivos produtos, possibilitando a inclusão, alteração e exclusão de pedidos e seus respectivos itens, além da pesquisa pelo código da venda ou através de uma interface de pequisa, permitindo a navegação entre registros, exibindo ou atualizando os dados armazenados no banco de dados.

![image](https://github.com/user-attachments/assets/993bd200-3ada-4369-8027-2df6483e16e2)


## Configurações

Para que seja possível a execução da aplicação, é necessário que seja criado um banco de dados MySQL ou MSSQL Server, cujo os scripts para criação do banco de dados (*Script Criação de
Tabelas MySQL.sql e Script Criação de Tabelas MSSQL.sql*), criação das tabelas utilizadas na aplicação e população de registros nas tabelas, encontra-se disponível dentro do projeto. 

Na pasta do projeto, encontra-se o arquivo *testeWK.ini* contendo as informações necessárias para que a aplicação conecte com o banco de dados criado anteriormente. Também encontra-se na pasta do projeto o arquivo *Instrução para configuração do banco de dados a ser utilizado.pdf*, contendo todas as instruções para execução do script de criação das tabelas e configuração do arquivo *testeWK.ini".

[Abrir PDF](Instrução para configuração do banco de dados a ser utilizado.pdf)

Com qualquer editor de arquivos TXT (ex: bloco de notas), é possível fazer as alterações no arquivo *testeWK.ini" para que seja possível realizar a conexão ao banco de dados e consequentemente, executar a apliacação sem erros.

## Arquitetura

A arquitetura do projeto segue o padrão MVC (Model-View-Controller), que permite uma separação clara de responsabilidades:

- **Model**: Contém as classes que representam os dados da aplicação e a lógica de negócios (por exemplo, `TProduto`, `TVendas`).
- **View**: São os formulários Delphi que apresentam a interface do usuário (por exemplo, `FrmMain`, `FrmCadVenda`).
- **Controller**: Realiza a comunicação entre o Model e a View, gerenciando a lógica de interação do usuário.

## Dicas de Uso

![image](https://github.com/user-attachments/assets/3d2ba708-8f40-4a4b-841f-31090fbc32fa)

A interface principal da aplicação é apresentada contendo os botões de opções (Produtos, Vendas e Sair), Através dessa interface que serão abertas as telas de uso da aplicação. 

### Cadastro de Produtos

![image](https://github.com/user-attachments/assets/1e83bea7-b09f-457d-a2f6-aa486598b996)

Na interface principal, ao clicar no botão **"Produtos"**, será exibida a interface de produtos, contendo os dados do produto, uma grade contendo todos os produtos cadastrados, uma área para pesquisa no grid (podendo ser alterada a forma de pesquisa por descrição ou codigo do produto), além dos botões de ação (Incluir, Alterar, Excluir, Gravar, Cancelar e Sair), localizados acima da tela.

Para selecionar um registro da grade, basta dar um duplo click no registro escolhido, que todas as informações do produtos serão mostradas na área destinada aos dados do produto. Pode-se também, navegar pela grade usando as setas e ao acionar a tecla <Enter> o registro será exibido na área de dados do produto, ja em estado de edição.

- Botão Inserir: Ao clicar no botão "**Inserir**", será liberada a área de dados do produto para a digitação das informações para a inclusão de um novo produto. Nesse momento, os botoes "**Gravar**" e "**Cancelar**" ficam habilitados e os demais botões ficam desabilitados, ficando para o usuário as opções de gravar o produto ou cancelar a inclusão.

- Botão Alterar: Após selecionar um registo na grade, fica habilitado o botão "**Alterar**"Ao clicar no botão "**Inserir**", será liberada a área de dados do produto para a digitação das informações para a inclusão de um novo produto. Nesse momento, os botoes "**Gravar**" e "**Cancelar**" ficam habilitados e os demais botões ficam desabilitados, ficando para o usuário as opções de gravar o produto ou cancelar a inclusão.


Ao Informar o cep a pesquisar e clicar no botão "Pesquisar", será preenchido automaticamente os campos relacionados ao endereço, ficando disponível para o usuário efetuar qualquer alteração nas informações obtidas atraves da API do ViaCep. Nesse momento é habilitado o botão "Inserir" e o botão "Cancelar", ficando desabilidado o grid e os demais botões. Caso deseje inserir o registro, basta clicar no botão "Inserir" que o mesmo será adicionado a base de dados existente, caso contrário, clicar no botão "cancelar" que a interface voltará ao estado inicial dela.

Para alterar ou excluir um registro incluido na base de dados, existe duas formas: efetuando om click duplo no registro escolhido no grid de endereços cadaastrados, nesse caso, será preenchido todos os campos relacionados ao endereço e ficando habilitado os botões "Alterar", "Excluir" e "Sair", conforme mostrado abaixo:

![image](https://github.com/user-attachments/assets/5a96e1d1-b4b8-4412-b19a-d72e366b7054)

Para alterar as informações, clicar no botão "Alterar" e realizar as alterações necessárias. Após efetuar as alterações clicar no botão "Gravar" para que as alterações sejam persistidas no banco de dados, caso contrário, clicar no botão "Cancelar" que as alterações serão desfeitas e a interface volta ao estado inicial dela.

A alteração de registros, pode ser feita também digitando o CEP no campo de pesquisa de CEP.

![image](https://github.com/user-attachments/assets/23b07c29-6fb7-4d9c-8c37-9f3557902047)

Neste caso, será informado ao usuário que foi encontrado um CEP na base de dados e solicitando que efetue a atualização (com base nas informações obtidas pela API ViaCep). Caso o usuário responda sim, serão preenchidos novamente os campos relacionados ao endereço, caso contrario, serão exibidos os campos que estão na base de dados.
A partir desse momento, a rotina permanece igual a anteriormente mencionada, permitindo o usuario alterar ou excluir o registro pesquisado.

### Pesquisa por Endereço

Para que possa ser feita a pesquisa pelo endereço, primeiro precisa alterar a opção de pesquisa para "Endereço". Nesse momento serão exibidos os campos necessários para efetuar a pesquisa.

![image](https://github.com/user-attachments/assets/c829d807-5384-4344-a53f-19c828e51dfc)

Todos os campos para pesquisa por endereço completo são de preenchimento obrigatório. Após preecher o endereço completo, basta clicar no botão "Pesquisar" que será feito o mesmo procedimento como na consulta por cep. No caso de pesquisa por endereço, é possivel quel o mesmo endereço possa existir com CEPs diferentes (logradouros com o mesmo nome em bairros distintos ou logradouro com varios CEPs), nesse caso, será exibida uma mensagem ao usuário informando que existe mais de um CEP para o endereço informado e solicitando se deseja visualiza-los. Caso o usuário escolha "Sim", será exibido uma nova janela mostrando todos os CEPs encontrados para o endereço informado.

![image](https://github.com/user-attachments/assets/160ccd29-9a80-4e2a-abac-c4ae0fe2f674)

Basta o usuário clicar no botão "Selecionar" ou dar um duplo click no registro escolhido no grid que serão preenchidas as informações na interface principal da aplicação.

![image](https://github.com/user-attachments/assets/fb6dee87-faf0-4b3c-82e9-06ecc611d993)

O mesmo procedimento de pesquisar um CEP que já existe na base de dados e que permite atualizar o endereço com as informações obtidas pelo webservice do ViaCep, ocorre também com a pesquisa por endereço completo.

![image](https://github.com/user-attachments/assets/31efa942-8a25-412b-a761-d6be479f15c8)



## Padrões Aplicados

- **Singleton**: Utilizado para a classe `TConnection`, garantindo que apenas uma instância da conexão com o banco de dados seja criada e utilizada.
- **Repository**: A classe `enderecorepository.model` atua como um repositório para realizar operações de CRUD no banco de dados.
- **Service**: A classe `TCEPService` encapsula a lógica de acesso à API ViaCEP, permitindo consultas de forma organizada.

## Boas Práticas

- **Clean Code**: O código foi escrito seguindo princípios de clean code, com nomes de variáveis e métodos claros, funções curtas e bem definidas.
- **Tratamento de Erros**: Implementação de mensagens amigáveis ao usuário para tratamento de erros e validação de dados.
- **Uso de Tabelas Temporárias**: Utilização de tabelas temporárias para armazenar dados intermediários durante as operações de consulta.
- **Configurações Externas**: O uso de um arquivo `consultaCEP.ini` para armazenar configurações do banco de dados, facilitando a manutenção e a portabilidade da aplicação.

