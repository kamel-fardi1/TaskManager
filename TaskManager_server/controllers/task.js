import Task from '../models/task.js';

var tasks = [];

export function getAll(req, res) {
   // console.log(tasks);
    res.status(200).json(tasks);
}

export function addAll(req, res) {
    tasks = [];
    console.log(req.body.data);
    req.body.data.forEach(element => {
        tasks.push(new Task(element.id, element.title, element.description, element.deadline, element.status));
    });
    res.status(201).json({ message: "Synchronized !" });
}