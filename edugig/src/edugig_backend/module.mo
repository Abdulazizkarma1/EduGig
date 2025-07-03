import Trie "mo:base/Trie";

actor class {
    // --- DATA MODELS ---

    public type Module = {
        id: Nat;
        title: Text;
        content: Text; // This could be markdown or a link to IPFS
        quiz: [Question];
    };

    public type Question = {
        text: Text;
        options: [Text];
        correctOption: Nat;
    };

    // --- STABLE STORAGE ---

    stable var modules = Trie.empty<Nat, Module>();
    stable var nextModuleId: Nat = 0;

    // --- MODULE MANAGEMENT ---

    public func addModule(title: Text, content: Text, quiz: [Question]) : async () {
        let module: Module = {
            id = nextModuleId;
            title = title;
            content = content;
            quiz = quiz;
        };
        modules := Trie.put(modules, nextModuleId, module);
        nextModuleId += 1;
    };

    public query func getModule(id: Nat) : async ?Module {
        return Trie.get(modules, id);
    };

    public query func listModules() : async [Module] {
        var allModules: [Module] = [];
        for ((_, module) in modules.entries()) {
            allModules := Array.append(allModules, [module]);
        };
        return allModules;
    };
}
