-- Criação da tabela Gender
CREATE TABLE Gender (
    gender_id INT PRIMARY KEY,         -- ID do gênero
    name VARCHAR(50) NOT NULL          -- Nome do gênero (e.g., Masculino, Feminino, Outro)
);

-- Criação da tabela Customer
CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,       -- ID do cliente
    name VARCHAR(100) NOT NULL,        -- Nome do cliente
    gender_id INT NOT NULL,            -- ID do gênero (chave estrangeira)
    address VARCHAR(255) NOT NULL,     -- Endereço do cliente
    birth_date DATE NOT NULL,          -- Data de nascimento do cliente 
    telephone VARCHAR(15),             -- Telefone do cliente
    is_seller BIT NOT NULL,            -- Se o cliente é vendedor (1 ou 0)
    created_at DATE DEFAULT GETDATE(), -- Data de criação
    updated_at DATE DEFAULT GETDATE(), -- Data de última atualização
    CONSTRAINT fk_gender FOREIGN KEY (gender_id) REFERENCES Gender(gender_id) -- Chave estrangeira
);

-- Criação da tabela Category
CREATE TABLE Category (
    category_id INT PRIMARY KEY,        -- ID da categoria
    name VARCHAR(255) NOT NULL,         -- Nome da categoria
    total_items_in_this_category INT,   -- Total de itens na categoria
    hierarchy_path VARCHAR(255) NOT NULL, -- Caminho hierárquico da categoria
    date_created DATE DEFAULT GETDATE(), -- Data de criação da categoria
    last_updated DATE DEFAULT GETDATE()  -- Data de última atualização
);

-- Criação da tabela Item
CREATE TABLE Item (
    item_id INT PRIMARY KEY,             -- ID do item
    name VARCHAR(255) NOT NULL,          -- Nome do item
    category_id INT NOT NULL,            -- ID da categoria do item (chave estrangeira)
    price DECIMAL(10, 2) NOT NULL,       -- Preço do item
    base_price DECIMAL(10, 2),           -- Preço base
    date_created DATE DEFAULT GETDATE(), -- Data de criação do item
    last_updated DATE DEFAULT GETDATE(), -- Data de última atualização
    is_enabled BIT DEFAULT 1,            -- Estado do item (ativo ou não)
    CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES Category(category_id) -- Chave estrangeira
);

-- Criação da tabela Status
CREATE TABLE Status (
    status_id INT PRIMARY KEY,           -- ID do status
    name VARCHAR(50) NOT NULL,           -- Nome do status (e.g., Pending, Completed, Canceled)
    [order] INT,                         -- Ordem de exibição do status
    color VARCHAR(20)                    -- Cor representando o status
);

-- Criação da tabela Order
CREATE TABLE [Order] (
    order_id INT PRIMARY KEY,           -- ID da ordem
    item_id INT NOT NULL,               -- ID do item comprado (chave estrangeira)
    buyer_id INT NOT NULL,              -- ID do comprador (chave estrangeira)
    seller_id INT NOT NULL,             -- ID do vendedor (chave estrangeira)
    quantity INT NOT NULL,              -- Quantidade comprada
    price DECIMAL(10, 2) NOT NULL,      -- Preço da ordem
    date_purchase DATE DEFAULT GETDATE(), -- Data da compra
    status_id INT NOT NULL,             -- ID do status (chave estrangeira)
    buyer_address VARCHAR(255),         -- Endereço do comprador
    CONSTRAINT fk_item FOREIGN KEY (item_id) REFERENCES Item(item_id),          -- Chave estrangeira
    CONSTRAINT fk_buyer FOREIGN KEY (buyer_id) REFERENCES Customer(customer_id), -- Chave estrangeira
    CONSTRAINT fk_seller FOREIGN KEY (seller_id) REFERENCES Customer(customer_id), -- Chave estrangeira
    CONSTRAINT fk_status FOREIGN KEY (status_id) REFERENCES Status(status_id)   -- Chave estrangeira
);


-- Criação da tabela Daily_Item_State
CREATE TABLE Daily_Item_State (
    item_id INT NOT NULL,               -- ID do item
    price DECIMAL(10, 2) NOT NULL,      -- Preço do item
    is_enabled BIT NOT NULL,            -- Estado do item (ativo/inativo)
    snapshot_date DATE NOT NULL,        -- Data do registro
    PRIMARY KEY (item_id, snapshot_date), -- Chave primária composta
    CONSTRAINT fk_item_daily FOREIGN KEY (item_id) REFERENCES Item(item_id) -- Chave estrangeira
);
