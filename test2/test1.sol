// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title SimpleToken
 * @dev 实现一个简单的ERC20代币合约
 */
contract SimpleToken {
    // 代币名称
    string public name;
    // 代币符号
    string public symbol;
    // 代币精度
    uint8 public decimals;
    // 总供应量
    uint256 public totalSupply;

    // 账户余额映射
    mapping(address => uint256) private _balances;
    // 授权额度映射
    mapping(address => mapping(address => uint256)) private _allowances;

    // 转账事件
    event Transfer(address indexed from, address indexed to, uint256 value);
    // 授权事件
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // 合约所有者
    address public myowner;

    /**
     * @dev 构造函数，初始化代币参数
     * @param _name 代币名称
     * @param _symbol 代币符号
     * @param _decimals 代币精度
     * @param _initialSupply 初始供应量
     */
    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _initialSupply
    ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _initialSupply * 10**_decimals;
        _balances[msg.sender] = totalSupply;
        myowner = msg.sender;
        
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    /**
     * @dev 查询账户余额
     * @param account 账户地址
     * @return 账户余额
     */
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev 转账功能
     * @param to 接收方地址
     * @param amount 转账金额
     * @return 是否成功
     */
    function transfer(address to, uint256 amount) public returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    /**
     * @dev 内部转账函数
     * @param from 发送方地址
     * @param to 接收方地址
     * @param amount 转账金额
     */
    function _transfer(address from, address to, uint256 amount) internal {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        
        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        
        _balances[from] = fromBalance - amount;
        _balances[to] += amount;
        
        emit Transfer(from, to, amount);
    }

    /**
     * @dev 授权功能
     * @param spender 被授权者地址
     * @param amount 授权金额
     * @return 是否成功
     */
    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    /**
     * @dev 内部授权函数
     * @param owner 授权者地址
     * @param spender 被授权者地址
     * @param amount 授权金额
     */
    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev 查询授权额度
     * @param owner 授权者地址
     * @param spender 被授权者地址
     * @return 授权额度
     */
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev 代扣转账功能
     * @param from 发送方地址
     * @param to 接收方地址
     * @param amount 转账金额
     * @return 是否成功
     */
    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        address spender = msg.sender;
        uint256 currentAllowance = _allowances[from][spender];
        require(currentAllowance >= amount, "ERC20: insufficient allowance");
        
        _transfer(from, to, amount);
        
        _approve(from, spender, currentAllowance - amount);
        return true;
    }

    /**
     * @dev 增发代币（仅合约所有者可调用）
     * @param to 接收新代币的地址
     * @param amount 增发数量
     */
    function mint(address to, uint256 amount) public {
        require(msg.sender == myowner, "Only owner can mint tokens");
        require(to != address(0), "ERC20: mint to the zero address");
        
        totalSupply += amount;
        _balances[to] += amount;
        
        emit Transfer(address(0), to, amount);
    }
}