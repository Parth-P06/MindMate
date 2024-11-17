module MentalHealthSupport::Network {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing a mental health support project.
    struct SupportProject has store, key {
        total_funds: u64,  // Total funds raised for the support project
        goal: u64,         // Funding goal for the project
        description: vector<u8>, // Description of the mental health support project
    }

    /// Function to create a new support project with a funding goal and description.
    public fun create_project(owner: &signer, goal: u64, description: vector<u8>) {
        let project = SupportProject {
            total_funds: 0,
            goal,
            description,
        };
        move_to(owner, project);
    }

    /// Function for users to contribute tokens to a support project.
    public fun contribute_to_project(contributor: &signer, project_owner: address, amount: u64) acquires SupportProject {
        let project = borrow_global_mut<SupportProject>(project_owner);

        // Transfer the contribution from the contributor to the project owner
        let contribution = coin::withdraw<AptosCoin>(contributor, amount);
        coin::deposit<AptosCoin>(project_owner, contribution);

        // Update the total funds raised
        project.total_funds = project.total_funds + amount;
    }
}
