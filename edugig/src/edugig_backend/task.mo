import Trie "mo:base/Trie";
import Principal "mo:base/Principal";
import Context "mo:base/Context";

actor class {
    // --- DATA MODELS ---

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
        content: Text; // Link to GitHub, file upload hash, etc.
        status: SubmissionStatus;
    };

    public type SubmissionStatus = {
        #Pending;
        #Approved;
        #Rejected;
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

    stable var tasks = Trie.empty<Nat, Task>();
    stable var submissions = Trie.empty<Nat, Submission>();
    stable var sbts = Trie.empty<Nat, SBT>();
    stable var nextTaskId: Nat = 0;
    stable var nextSubmissionId: Nat = 0;
    stable var nextSbtId: Nat = 0;

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

    // --- SUBMISSION MANAGEMENT ---

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
        let caller = Context.caller();
        let submission = Trie.get(submissions, submissionId)!;
        submissions := Trie.put(submissions, submissionId, { ...submission, status = #Approved });

        // Mint SBT
        let sbt: SBT = {
            id = nextSbtId;
            learnerId = submission.learnerId;
            taskId = submission.taskId;
            date = Time.now();
            validatorId = caller;
            taskContentHash = submission.content;
        };
        sbts := Trie.put(sbts, nextSbtId, sbt);
        nextSbtId += 1;
    };

    public func rejectSubmission(submissionId: Nat) : async () {
        let submission = Trie.get(submissions, submissionId)!;
        submissions := Trie.put(submissions, submissionId, { ...submission, status = #Rejected });
    };
}
