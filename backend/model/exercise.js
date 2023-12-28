module.exports = class Exercise {
    constructor(name, sets, restMinutes, reps) {
        this.name = name;
        this.sets = sets;
        this.restMinutes = restMinutes;
        this.reps = reps;
        this.id = name + sets + restMinutes + reps
    }

    getJSON() {
        return (
            `exercises:${this.id}`, {
                "name" : this.name,
                "sets" : this.sets,
                "rest_minutes" : this.restMinutes,
                "reps" : this.reps
            })
    }
}
