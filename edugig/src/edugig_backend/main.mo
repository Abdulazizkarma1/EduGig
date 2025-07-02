import Trie "mo:base/Trie";
import Principal "mo:base/Principal";
import Context "mo:base/Context";

actor {
    // --- DATA MODELS ---

    public type Role = {
        #Learner;
        #Validator;
        #TaskPoster;
        #Admin;
    };

    public type UserProfile = {
        role: Role;
        name: Text;
        badges: [SBT];
    };

    public type SBT = {
        id: Nat;
        learnerId: Principal;
        taskId: Nat;
        date: Nat; // Timestamp
        validatorId: Principal;
        taskContentHash: Text;
    };

    // --- STABLE STORAGE ---

    stable var users = Trie.empty<Principal, UserProfile>();

    // --- USER MANAGEMENT ---

    public query func getUser(id: Principal) : async ?UserProfile {
        return Trie.get(users, id);
    };

    public func createUser(role: Role, name: Text) : async () {
        let caller = Context.caller();
        let userProfile: UserProfile = {
            role = role;
            name = name;
            badges = [];
        };
        users := Trie.put(users, caller, userProfile);
    };
}
