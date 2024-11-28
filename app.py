class Notes:
    def __init__ (self):
        self.stack = []

    def addnote (self, note):
        if not isinstance(note, str) or not note.strip():
            raise ValueError("Нотатка порожня")
        self.stack.append(note)

    def is_empty (self):
        return len(self.stack) == 0

    def removenote (self):
        if self.is_empty():
            raise IndexError("Нотатки немає")
        return self.stack.pop()
        
    def viewnote (self):
        if self.is_empty():
            raise IndexError("Нотатки немає")
        return self.stack[-1]
    
    def searchnote (self, text):
        found_notes = [note for note in self.stack if text in note]
        if not found_notes:
            raise ValueError("Нотатка не знайдена")
        return found_notes
    