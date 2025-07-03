import Array "mo:base/Array";
import Trie "mo:base/Trie";
import Principal "mo:base/Principal";
import Context "mo:base/Context";
import Time "mo:base/Time";

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

    public type Module = {
        id: Nat;
        title: Text;
        content: Text;
        quiz: [Question];
    };

    public type Question = {
        text: Text;
        options: [Text];
        correctOption: Nat;
    };

    public type Task = {
        id: Nat;
        moduleId: Nat;
        title: Text;
        description: Text;
    };

    public type Submission = {
        id: Nat;
        taskId: Nat;
        learnerId: Principal;
        content: Text;
        status: SubmissionStatus;
    };

    public type SubmissionStatus = {
        #Pending;
        #Approved;
        #Rejected;
    };

    // --- STABLE STORAGE ---

    stable var users = Trie.empty<Principal, UserProfile>();
    stable var modules = Trie.empty<Nat, Module>();
    stable var tasks = Trie.empty<Nat, Task>();
    stable var submissions = Trie.empty<Nat, Submission>();
    stable var sbts = Trie.empty<Nat, SBT>();

    stable var nextModuleId: Nat = 0;
    stable var nextTaskId: Nat = 0;
    stable var nextSubmissionId: Nat = 0;
    stable var nextSbtId: Nat = 0;

    // --- USER MANAGEMENT ---

    public query func getUser(id: Principal) : async ?UserProfile {
        return Trie.get(users, id);
    };

    public func createUser(role: Role, name: Text) : async () {
        let caller = Context.caller();
        if (Trie.get(users, caller) != null) {
            return; // User already exists
        };
        let userProfile: UserProfile = {
            role = role;
            name = name;
            badges = [];
        };
        users := Trie.put(users, caller, userProfile);
    };

    // --- MODULE MANAGEMENT ---

    public func addModule(title: Text, content: Text, quiz: [Question]) : async () {
        let learningModule: Module = {
            id = nextModuleId;
            title = title;
            content = content;
            quiz = quiz;
        };
        modules := Trie.put(modules, nextModuleId, learningModule);
        nextModuleId += 1;
    };

    public query func getModule(id: Nat) : async ?Module {
        return Trie.get(modules, id);
    };

    public query func listModules() : async [Module] {
        var allModules: [Module] = [];
        for ((_, learningModule) in modules.entries()) {
            allModules := Array.append(allModules, [learningModule]);
        };
        return allModules;
    };

    // --- TASK MANAGEMENT ---

    public func createTask(moduleId: Nat, title: Text, description: Text) : async () {
        let task: Task = {
            id = nextTaskId;
            moduleId = moduleId;
            title = title;
            description = description;
        };
        tasks := Trie.put(tasks, nextTaskId, task);
        nextTaskId += 1;
    };

    public query func getTask(id: Nat) : async ?Task {
        return Trie.get(tasks, id);
    };

    public query func listTasks() : async [Task] {
        var allTasks: [Task] = [];
        for ((_, task) in tasks.entries()) {
            allTasks := Array.append(allTasks, [task]);
        };
        return allTasks;
    };

    // --- SUBMISSION & SBT MANAGEMENT ---

    public func submitTask(taskId: Nat, content: Text) : async () {
        let caller = Context.caller();
        let submission: Submission = {
            id = nextSubmissionId;
            taskId = taskId;
            learnerId = caller;
            content = content;
            status = #Pending;
        };
        submissions := Trie.put(submissions, nextSubmissionId, submission);
        nextSubmissionId += 1;
    };

    public func approveSubmission(submissionId: Nat) : async () {
        let validatorId = Context.caller();
        switch (Trie.get(submissions, submissionId)) {
            case (null) { return; }; // Or throw error
            case (?submission) {
                if (submission.status != #Pending) { return; };

                submissions := Trie.put(submissions, submissionId, { ...submission, status = #Approved });

                let sbt: SBT = {
                    id = nextSbtId;
                    learnerId = submission.learnerId;
                    taskId = submission.taskId;
                    date = Time.now();
                    validatorId = validatorId;
                    taskContentHash = submission.content;
                };
                sbts := Trie.put(sbts, nextSbtId, sbt);
                nextSbtId += 1;

                switch (Trie.get(users, submission.learnerId)) {
                    case (?userProfile) {
                        let updatedProfile = { ...userProfile, badges = Array.append(userProfile.badges, [sbt]) };
                        users := Trie.put(users, submission.learnerId, updatedProfile);
                    };
                    case (null) {};
                };
            };
        };
    };

    public func rejectSubmission(submissionId: Nat) : async () {
        switch (Trie.get(submissions, submissionId)) {
            case (null) { return; };
            case (?submission) {
                if (submission.status != #Pending) { return; };
                submissions := Trie.put(submissions, submissionId, { ...submission, status = #Rejected });
            };
        };
    };
}
