contract Permissions {
  function has_base(address addr, int permFlag) constant returns (bool value) {}
  function set_base(address addr, int permFlag, bool value) constant returns (bool val) {}
  function unset_base(address addr, int permFlag) constant returns (int pf) {}
  function set_global(address addr, int permFlag, bool value) constant returns (int pf) {}
  function has_role(address addr, string role) constant returns (bool val) {}
  function add_role(address addr, string role) constant returns (bool added) {}
  function rm_role(address addr, string role) constant returns (bool removed) {}
}

contract Incrementor {
  uint red = 0;
  uint blue = 0;
  address owner;

  event Incremented(address indexed incrementor, string indexed colour, uint indexed val);

  event Invoked(address indexed invoker);

  Permissions p = Permissions(address(sha256("permissions_contract")));

  function Incrementor() {
    owner = msg.sender;
  }

  function increment() {
    Invoked(msg.sender);

    if (p.has_role(msg.sender, "red")) {
      red += 1;
      Incremented(msg.sender, "red", red);
    }

    if (p.has_role(msg.sender, "blue")) {
      blue += 1;
      Incremented(msg.sender, "blue", blue);
    }
  }

  function terminate() {
    if (msg.sender == owner)
      suicide(owner);
  }
}
