import Trie "mo:base/Trie";
import Principal "mo:base/Principal";
import Context "mo:base/Context";

actor class EduGig() {

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

    public type Lesson = {
        id: Nat;
        title: Text;
        content: Text; // Can be markdown or IPFS hash
        quiz: [(Text, Bool)]; // A simple quiz with question and correct answer
    };

    public type Task = {
        id: Nat;
        title: Text;
        description: Text;
        moduleId: Nat;
    };

    public type SubmissionStatus = {
        #Pending;
        #Approved;
        #Rejected;
    };

    public type Submission = {
        id: Nat;
        taskId: Nat;
        learnerId: Principal;
        content: Text; // Link to GitHub, file hash, etc.
        status: SubmissionStatus;
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
    stable var lessons = Trie.empty<Nat, Lesson>();
    stable var tasks = Trie.empty<Nat, Task>();
    stable var submissions = Trie.empty<Nat, Submission>();
    stable var sbts = Trie.empty<Nat, SBT>();

    // --- USER MANAGEMENT ---

    public query func getUser(id: Principal) : async ?UserProfile {
        return Trie.get(users, id);
    };

    public update func createUser(role: Role, name: Text) : async () {
        let caller = Context.caller();
        let userProfile: UserProfile = {
            role = role;
            name = name;
            badges = [];
        };
        users := Trie.put(users, caller, userProfile);
    };
}
