module.exports = class Exercise {
    constructor(name, sets, restMinutes, reps, id) {
        this.name = name;
        this.sets = sets;
        this.restMinutes = restMinutes;
        this.reps = reps;
        this.id = id
    }

    getJSON() {
        return {
            "name" : this.name,
                "sets" : this.sets,
                "restMinutes" : this.restMinutes,
                "reps" : this.reps
        }
    }
}
