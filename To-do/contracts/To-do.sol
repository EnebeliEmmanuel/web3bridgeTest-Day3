// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

/// @title creating a simple todo-list contract for myself
/// @author Kokocodes
/// @dev Contract emits a task created events in logic
/// @dev Contract emits a task completed events in logic
contract TodoList {
  struct Task {
    uint id;
    uint date;
    string content;
    string author;
    bool done;
    uint dateComplete;
  }

  uint lastTaskId;
  uint[] taskIds;
  mapping(uint => Task) tasks;

 ///======================= EVENTS ==============================
  event TaskCreated(
    uint id,
    uint date,
    string content,
    string author,
    bool done);

  event TasksCompleted(uint id, bool done, uint date);

  constructor() public {
    lastTaskId = 0;
  }

    /// ==================== PUBLIC FUNCTIONS ================================
  function createTask(string memory _content, string memory _author) public {
    lastTaskId++;
    tasks[lastTaskId] = Task(lastTaskId, now, _content, _author, false, 0);
    taskIds.push(lastTaskId);
    emit TaskCreated(lastTaskId, now, _content, _author, false);
  }


    /// ==================== PUBLIC FUNCTIONS ================================
  function getTaskIds() public view returns(uint[] memory) {
    return taskIds;
  }


    /// ==================== PUBLIC FUNCTIONS ================================
  function getTask(uint id) taskExists(id) public view
    returns(
      uint,
      uint,
      string memory,
      string memory,
      bool,
      uint
    ) {

      return(
        id,
        tasks[id].date,
        tasks[id].content,
        tasks[id].author,
        tasks[id].done,
        tasks[id].dateComplete
      );
    }


    /// ==================== PUBLIC FUNCTIONS ================================
    function toggleDone(uint id) taskExists(id) public {
      Task storage task = tasks[id];
      task.done = !task.done;
      task.dateComplete = task.done ? now : 0;
     emit TasksCompleted(id, task.done, task.dateComplete);
    }



/**
*@notice modifier to check if task exits or not
*/
    modifier taskExists(uint id) {
      if(tasks[id].id == 0) {
        revert("not exist");
      }
      _;
    }
}