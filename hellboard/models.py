from sqlalchemy import (
    Column,
    Integer,
    Text,
    DateTime,    
    )

from sqlalchemy.ext.declarative import declarative_base

from sqlalchemy.orm import (
    scoped_session,
    sessionmaker,
    )

from zope.sqlalchemy import ZopeTransactionExtension

from datetime import datetime

DBSession = scoped_session(sessionmaker(extension=ZopeTransactionExtension()))
Base = declarative_base()

class Post(Base):
    """Textboard post"""
    __tablename__ = 'posts'
    __table_args__ = {'sqlite_autoincrement': True}
    id = Column(Integer, primary_key=True)
    text = Column(Text)
    formatted_text = Column(Text)
    threadId = Column(Integer, nullable = False)
    boardId = Column(Integer, nullable = False)
    postingDateTime = Column(DateTime, nullable = False, default = datetime.utcnow)

    def __init__(self, text, boardId, threadId):
        self.text = text
        self.formatted_text = ''
        self.threadId = threadId
        self.boardId = boardId

    @classmethod
    def GetAll(cls):
        return DBSession.query(cls).all()

# todo: topic field

class Thread(Base):
    """Board Thread"""
    __tablename__ = 'threads'
    __table_args__ = {'sqlite_autoincrement': True}
    id = Column(Integer, primary_key=True)
    boardId = Column(Integer, nullable = False)
    opPostId = Column(Integer)
    def __init__(self, boardId):
        self.boardId = boardId

    # primary key (board_id, id) - todo

class Board(Base):
    """Board board"""
    __tablename__ = 'boards'
    __table_args__ = {'sqlite_autoincrement': True}
    id = Column(Integer, primary_key=True)
    name = Column(Text, nullable=False, unique = True)
    title = Column(Text, nullable=False)
    description = Column(Text, nullable=False)
    def __init__(self, name, title, description):
        self.name = name
        self.title = title
        self.description = description

    @classmethod
    def GetAll(cls):
        return DBSession.query(cls).all()
